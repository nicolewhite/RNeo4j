use std::{slice, str, fmt, ptr};
use std::any::Any;
use std::marker::PhantomData;
use std::ffi::{CStr, CString};

use rustr::*;
use bindings::*;

// Defined as a macro in the header
pub(crate) fn neo4j_type(value: neo4j_value_t) -> neo4j_type_t {
    return value._type;
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
}

impl<'a> IntoR for ValueRef<'a> {
    fn intor(&self) -> RResult<SEXP> {
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
                let properties = neo4j_node_properties(value);
                let len = neo4j_map_size(properties);
                let mut rlist = RList::alloc(len as _);
                let mut names = CharVec::alloc(len as _);
                for i in 0..len {
                    let entry = neo4j_map_getentry(properties, i);
                    let key = (*entry).key;
                    let value = (*entry).value;
                    let key_slice = slice::from_raw_parts(
                        neo4j_ustring_value(key) as *const u8,
                        neo4j_string_length(key) as usize
                    );
                    names.set(i as _, str::from_utf8_unchecked(key_slice))?;
                    rlist.set(i as _, ValueRef::from_c_ty(value).intor()?)?;
                }
                rlist.set_name(&names)?;
                rlist.set_attr::<_, _, Preserve>("class", "boltNode".intor()?);
                rlist.set_attr::<_, _, Preserve>("labels", Value::from_c_ty(neo4j_node_labels(value)).intor()?);
                rlist.intor()
            } else if ty == NEO4J_LIST {
                let len = neo4j_list_length(value) as usize;
                let mut rlist = RList::alloc(len);
                for i in 0..len {
                    rlist.set(i, ValueRef::from_c_ty(neo4j_list_get(value, i as _)).intor()?)?;
                }
                rlist.intor()
            } else {
                stop!("Cannot convert Neo4j type to R type: {}", self.typestr().to_string_lossy())
            }
        }
    }
}

pub struct Value {
    pub(crate) inner: neo4j_value_t,
    pub(crate) store: Option<Box<Any>>,
}

impl Value {
    pub(crate) unsafe fn from_c_ty(value: neo4j_value_t) -> Value {
        Value {
            inner: value,
            store: None,
        }
    }

    pub fn null() -> Value {
        unsafe {
            Value {
                inner: neo4j_null,
                store: None,
            }
        }
    }

    pub fn from_string(value: String) -> Value {
        unsafe {
            Value {
                inner: neo4j_ustring(value.as_ptr() as _, value.len() as _),
                store: Some(Box::new(value) as Box<Any>),
            }
        }
    }

    pub fn from_cstring(value: CString) -> Value {
        unsafe {
            Value {
                inner: neo4j_ustring(value.as_ptr() as _, value.to_bytes().len() as _),
                store: Some(Box::new(value) as Box<Any>),
            }
        }
    }

    pub fn borrow<'a>(&'a self) -> ValueRef<'a> {
        unsafe {
            ValueRef::from_c_ty(self.inner)
        }
    }

    pub fn typestr(&self) -> &'static CStr {
        self.borrow().typestr()
    }
}

impl<'a> fmt::Display for ValueRef<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let mut buf = vec![0u8; 64];
        unsafe {
            let len = neo4j_ntostring(self.inner, buf.as_ptr() as _, buf.len());
            let orig_len = buf.len();
            buf.resize(len + 1, 0);
            if len > orig_len {
                let new_len = neo4j_ntostring(self.inner, buf.as_ptr() as _, buf.len());
                buf.truncate(new_len + 1);
            }
        }
        assert_eq!(buf.pop(), Some(0));
        write!(f, "{}", CString::new(buf).map_err(|_| fmt::Error)?.into_string().map_err(|_| fmt::Error)?)
    }
}

impl fmt::Display for Value {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.borrow().fmt(f)
    }
}

impl IntoR for Value {
    fn intor(&self) -> RResult<SEXP> {
        self.borrow().intor()
    }
}

macro_rules! impl_from_primitive {
    ($x:ty, $y:expr) => {
        impl From<$x> for Value {
            fn from(x: $x) -> Value {
                unsafe {
                    Value::from_c_ty($y(x as _))
                }
            }
        }
    };
}

impl_from_primitive!(bool, neo4j_bool);
impl_from_primitive!(i32, neo4j_int);
impl_from_primitive!(i64, neo4j_int);
impl_from_primitive!(f32, neo4j_float);
impl_from_primitive!(f64, neo4j_float);

impl From<String> for Value {
    fn from(x: String) -> Value {
        Value::from_string(x)
    }
}

impl From<CString> for Value {
    fn from(x: CString) -> Value {
        Value::from_cstring(x)
    }
}

fn into_type<T: Into<Value>>(r: SEXP) -> RResult<Value>
    where Vec<T>: RNew
{
    let mut rvec = Vec::<T>::rnew(r)?;
    if rvec.len() == 0 {
        unsafe {
            return Ok(Value::from_c_ty(neo4j_list(ptr::null(), 0)));
        }
    }
    if rvec.len() == 1 {
        return Ok(rvec.pop().unwrap().into());
    }
    let mut store: Vec<Box<Any>> = Vec::new();
    let mut items: Vec<neo4j_value_t> = Vec::new();
    for value in rvec {
        let value = value.into();
        items.push(value.inner);
        if let Some(vstore) = value.store {
            store.push(vstore);
        }
    }
    let list = unsafe { neo4j_list(items.as_ptr(), items.len() as _) };
    store.push(Box::new(items) as Box<Any>);
    Ok(Value {
        inner: list,
        store: Some(Box::new(store) as Box<Any>),
    })
}

impl RNew for Value {
    fn rnew(r: SEXP) -> RResult<Value> {
        unsafe {
            let rty = RTYPEOF(r);
            if rty == NILSXP {
                Ok(Value::from_c_ty(neo4j_null))
            } else if rty == LGLSXP {
                into_type::<bool>(r)
            } else if rty == INTSXP {
                into_type::<i64>(r)
            } else if rty == REALSXP {
                into_type::<f64>(r)
            } else if rty == STRSXP {
                into_type::<String>(r)
            } else if rty == VECSXP {
                let list = RList::rnew(r)?;
                if list.rsize() == 0 {
                    return Ok(Value {
                        inner: neo4j_map(ptr::null(), 0),
                        store: None,
                    });
                }
                let names = RName::get_name::<Vec<CString>>(&list)?;
                let mut store: Vec<Box<Any>> = Vec::new();
                let entries = names.into_iter().zip(list.into_iter())
                    .map(|(k, v)| -> Result<_, RError> {
                        let value = Value::rnew(v)?;
                        if let Some(obj) = value.store {
                            store.push(obj);
                        }
                        let nkey = neo4j_ustring(k.as_ptr(), k.to_bytes().len() as _);
                        let entry = neo4j_map_kentry(nkey, value.inner);
                        store.push(Box::new(k) as Box<Any>);
                        Ok(entry)
                    })
                    .collect::<Result<Vec<_>, _>>()?;
                let map = neo4j_map(entries.as_ptr(), entries.len() as _);
                store.push(Box::new(entries) as _);
                Ok(Value {
                    inner: map,
                    store: Some(Box::new(store) as Box<Any>),
                })
            } else {
                stop!("Cannot convert R type {} to Neo4j type", RTYPEOF(r))
            }
        }
    }
}
