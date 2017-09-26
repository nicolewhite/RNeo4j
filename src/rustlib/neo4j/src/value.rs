use std::{str, fmt, ptr};
use std::any::Any;
use std::ffi::{CStr, CString};

use rustr::*;
use rustr::rptr::RPtr;
use bindings::*;

use graph::Graph;
use value_ref::ValueRef;

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

    pub fn intor(&self, graph: &mut RPtr<Graph>) -> RResult<SEXP> {
        unsafe {
            let ty = neo4j_type(self.inner);
            if ty == NEO4J_IDENTITY {
                RPtr::new(Box::new(Value::from_c_ty(self.inner))).intor()
            } else {
                self.borrow().intor(graph)
            }
        }
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
                return Ok(Value::from_c_ty(neo4j_null));
            }
            // TODO there should be a better way to do this
            if rty != EXTPTRSXP && RFun::from_str_global("is.na")?.eval(&[&r])? {
                return Ok(Value::from_c_ty(neo4j_null));
            }
            if rty == LGLSXP {
                into_type::<bool>(r)
            } else if rty == INTSXP {
                into_type::<i64>(r)
            } else if rty == REALSXP {
                into_type::<f64>(r)
            } else if rty == STRSXP {
                into_type::<String>(r)
            } else if rty == VECSXP {
                let list = RList::rnew(r)?;
                if let Ok(identity) = list.get_attr::<SEXP, Preserve, _>("boltIdentity") {
                    if RTYPEOF(identity) != NILSXP {
                        return Value::rnew(identity);
                    }
                }
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
            } else if rty == EXTPTRSXP {
                let mut rptr: RPtr<Value> = RPtr::rnew(r)?;
                let ref value_ref = rptr.get()?;
                assert!(value_ref.store.is_none(), "Encountered R Pointer to Value with store");
                Ok(Value::from_c_ty(value_ref.inner))
            } else {
                stop!("Cannot convert R type {} to Neo4j type", RTYPEOF(r))
            }
        }
    }
}
