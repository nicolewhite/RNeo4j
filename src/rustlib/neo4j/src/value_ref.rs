use std::{slice, str, ptr};
use std::marker::PhantomData;
use std::ffi::{CStr, CString};

use rustr::*;
use rustr::rptr::RPtr;
use bindings::*;

use graph::Graph;
use value::Value;

const NODE_ENDPOINTS: &[(&str, &str)] = &[
    ("self", ""),
    ("property", "/properties/{key}"),
    ("properties", "/properties"),
    ("labels", "/labels"),
    ("create_relationship", "/relationships"),
    ("incoming_relationships", "/relationships/in"),
    ("outgoing_relationships", "/relationships/out"),
];

const RELATIONSHIP_ENDPOINTS: &[(&str, &str)] = &[
    ("self", ""),
    ("property", "/properties/{key}"),
    ("properties", "/properties"),
];

unsafe fn map_to_rlist(value: neo4j_value_t, graph: &mut RPtr<Graph>) -> RResult<RList> {
    assert_eq!(neo4j_type(value), NEO4J_MAP);
    let len = neo4j_map_size(value);
    let mut rlist = RList::alloc(len as _);
    let mut names = CharVec::alloc(len as _);
    for i in 0..len {
        let entry = neo4j_map_getentry(value, i);
        let key = (*entry).key;
        let value = (*entry).value;
        let key_slice = slice::from_raw_parts(
            neo4j_ustring_value(key) as *const u8,
            neo4j_string_length(key) as usize
        );
        names.set(i as _, str::from_utf8_unchecked(key_slice))?;
        rlist.set(i as _, ValueRef::from_c_ty(value).intor(graph)?)?;
    }
    rlist.set_name(&names)?;
    Ok(rlist)
}

unsafe fn identity_to_int(mut ident: neo4j_value_t) -> i64 {
    // TODO this is *extremely* hacky, but there's no better way by design
    ident._type = NEO4J_INT;
    neo4j_int_value(ident)
}

unsafe fn configure_entity<RT: RAttribute>(
    graph: &mut RPtr<Graph>, robj: &mut RT, ident: neo4j_value_t, name: &'static str,
    bolt_name: &'static str, http_endpoints: &'static [(&'static str, &'static str)]
) -> RResult<()> {
    // to get around borrow checker
    let maybe_class = ["boltEntity", "entity", bolt_name, name];
    let mut class: &[&'static str] = &["boltEntity", bolt_name];
    robj.set_attr::<_, _, Preserve>("boltGraph", graph.intor()?);
    robj.set_attr::<_, _, Preserve>("boltIdentity", Value::from_c_ty(ident).intor(graph)?);
    let id = identity_to_int(ident);
    robj.set_attr::<_, _, Preserve>("boltId", id.intor()?);
    if let Some(ref http_url) = graph.get()?.http_url {
        class = &maybe_class;
        for &(k, v) in http_endpoints {
            let v = format!("{}{}/{}{}", http_url, name, id, v);
            robj.set_attr::<_, _, Preserve>(k, v.intor()?);
        }
    }
    robj.set_attr::<_, _, Preserve>("class", class.intor()?);
    Ok(())
}

fn unlist_items(rlist: &mut RList) -> RResult<()> {
    for i in 0..rlist.rsize() {
        if let Some(item) = rlist.at(i as _) {
            rlist.set(i as _, RFun::from_str_global("unlist")?.eval::<SEXP>(&[&item])?)?;
        }
    }
    Ok(())
}

pub struct ValueRef<'a> {
    pub(crate) inner: neo4j_value_t,
    phantom: PhantomData<&'a ()>,
}

impl<'a> ValueRef<'a> {
    pub(crate) unsafe fn from_c_ty(value: neo4j_value_t) -> ValueRef<'a> {
        ValueRef {
            inner: value,
            phantom: PhantomData,
        }
    }

    pub fn from_str(value: &'a str) -> ValueRef<'a> {
        unsafe {
            ValueRef::from_c_ty(neo4j_ustring(value.as_ptr() as _, value.len() as _))
        }
    }

    pub fn null() -> ValueRef<'static> {
        unsafe {
            ValueRef {
                inner: neo4j_null,
                phantom: PhantomData,
            }
        }
    }

    pub fn is_r_primitive(&self) -> bool {
        unsafe {
            let ty = neo4j_type(self.inner);
            ty == NEO4J_NULL || ty == NEO4J_BOOL ||
                ty == NEO4J_INT || ty == NEO4J_FLOAT ||
                ty == NEO4J_STRING || ty == NEO4J_LIST ||
                ty == NEO4J_MAP
        }
    }

    pub fn typestr(&self) -> &'static CStr {
        unsafe {
            CStr::from_ptr(neo4j_typestr(neo4j_type(self.inner)))
        }
    }

    pub fn intor(&self, graph: &mut RPtr<Graph>) -> RResult<SEXP> {
        unsafe {
            let value = self.inner;
            let ty = neo4j_type(value);
            if ty == NEO4J_NULL {
                Ok(rstatic::rnull())
            } else if ty == NEO4J_BOOL {
                neo4j_bool_value(value).intor()
            } else if ty == NEO4J_INT {
                neo4j_int_value(value).intor()
            } else if ty == NEO4J_FLOAT {
                neo4j_float_value(value).intor()
            } else if ty == NEO4J_STRING {
                let s = slice::from_raw_parts(
                    neo4j_ustring_value(value) as *const u8,
                    neo4j_string_length(value) as usize
                );
                str::from_utf8_unchecked(s).intor()
            } else if ty == NEO4J_NODE {
                let mut rlist = map_to_rlist(neo4j_node_properties(value), graph)?;
                configure_entity(graph, &mut rlist, neo4j_node_identity(value),
                    "node", "boltNode", NODE_ENDPOINTS)?;
                unlist_items(&mut rlist)?;
                rlist.intor()
            } else if ty == NEO4J_RELATIONSHIP {
                let mut rlist = map_to_rlist(neo4j_relationship_properties(value), graph)?;
                configure_entity(graph, &mut rlist, neo4j_relationship_identity(value),
                    "relationship", "boltRelationship", RELATIONSHIP_ENDPOINTS)?;
                rlist.set_attr::<_, _, Preserve>("type", Value::from_c_ty(neo4j_relationship_type(value)).intor(graph)?);
                let start_ident = neo4j_relationship_start_node_identity(value);
                let end_ident = neo4j_relationship_end_node_identity(value);
                rlist.set_attr::<_, _, Preserve>("boltStartIdent", Value::from_c_ty(start_ident).intor(graph)?);
                rlist.set_attr::<_, _, Preserve>("boltEndIdent", Value::from_c_ty(end_ident).intor(graph)?);
                if let Some(ref http_url) = graph.get()?.http_url {
                    for &(name, ident) in &[("start", start_ident), ("end", end_ident)] {
                        rlist.set_attr::<_, _, Preserve>(name, format!("{}node/{}", http_url, identity_to_int(ident)).intor()?);
                    }
                }
                unlist_items(&mut rlist)?;
                rlist.intor()
            } else if ty == NEO4J_PATH {
                let mut rlist = RList::alloc(1);
                let len = neo4j_path_length(value);
                rlist.set(0, len.intor()?)?;
                let name = CharVec::from(vec![CString::new("length").unwrap()]);
                rlist.set_name(&name)?;
                if len > 0 {
                    for &(n, i) in &[("boltStartIdent", 0), ("boltEndIdent", len)] {
                        rlist.set_attr::<_, _, Preserve>(n, Value::from_c_ty(neo4j_node_identity(neo4j_path_get_node(value, i))).intor(graph)?);
                    }
                }
                rlist.set_attr::<_, _, Preserve>("boltGraph", graph.intor()?);
                if let Some(ref http_url) = graph.get()?.http_url {
                    rlist.set_attr::<_, _, Preserve>("class", (&["boltPath", "path"] as &[_]).intor()?);
                    for &(n, i) in &[("start", 0), ("end", len)] {
                        let ident = neo4j_node_identity(neo4j_path_get_node(value, i));
                        let url = format!("{}node/{}", http_url, identity_to_int(ident));
                        rlist.set_attr::<_, _, Preserve>(n, url.intor()?);
                    }
                    let nnodes = if len == 0 { 0 } else { len + 1 };
                    let mut node_urls = CharVec::alloc(nnodes as _);
                    for i in 0..nnodes {
                        let ident = neo4j_node_identity(neo4j_path_get_node(value, i));
                        let url = format!("{}node/{}", http_url, identity_to_int(ident));
                        node_urls.set(i as _, &url)?;
                    }
                    rlist.set_attr::<_, _, Preserve>("nodes", node_urls.intor()?);
                    let mut rel_urls = CharVec::alloc(len as _);
                    for i in 0..len {
                        let ident = neo4j_relationship_identity(neo4j_path_get_relationship(value, i, ptr::null_mut()));
                        let url = format!("{}relationship/{}", http_url, identity_to_int(ident));
                        rel_urls.set(i as _, &url)?;
                    }
                    rlist.set_attr::<_, _, Preserve>("relationships", rel_urls.intor()?);
                } else {
                    rlist.set_attr::<_, _, Preserve>("class", (&["boltPath"] as &[_]).intor()?);
                }
                rlist.intor()
            } else if ty == NEO4J_LIST {
                let len = neo4j_list_length(value);
                let mut rlist = RList::alloc(len as _);
                for i in 0..len {
                    rlist.set(i as _, ValueRef::from_c_ty(neo4j_list_get(value, i)).intor(graph)?)?;
                }
                rlist.intor()
            } else if ty == NEO4J_BYTES {
                let slice = slice::from_raw_parts(neo4j_bytes_value(value) as *const u8, neo4j_bytes_length(value) as _);
                let mut rawvec = RawVec::alloc(slice.len());
                for (i, &b) in slice.into_iter().enumerate() {
                    rawvec.set(i, b)?;
                }
                rawvec.intor()
            } else if ty == NEO4J_MAP {
                map_to_rlist(value, graph)?.intor()
            } else {
                stop!("Cannot convert Neo4j type to R type: {}", self.typestr().to_string_lossy())
            }
        }
    }
}
