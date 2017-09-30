use std::ffi::CString;

extern crate rustr;
use rustr::*;
use rustr::rptr::RPtr;

pub struct Graph;
pub struct Value;

impl RNew for Value {
    fn rnew(_: SEXP) -> RResult<Value> {
        Ok(Value)
    }
}

pub fn bolt_begin_internal(_: CString, _: Vec<String>, _: Vec<CString>, _: Vec<CString>) -> RResult<RPtr<Graph>> {
    Err(RError::forcestop("Bolt support was not built, as either libneo4j-client or libclang were missing".into()))
}

pub fn bolt_query_internal(_: RPtr<Graph>, _: CString, _: Value, _: bool) -> RResult<RList> {
    Err(RError::forcestop("Bolt support was not built, as either libneo4j-client or libclang were missing".into()))
}

pub fn bolt_supported_internal() -> bool {
    false
}
