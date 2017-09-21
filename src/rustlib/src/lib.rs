use std::ffi::CString;

#[macro_use]
extern crate rustr;
pub mod export;
pub use rustr::*;
use rustr::rptr::RPtr;

#[macro_use]
extern crate neo4j;
use neo4j::{Graph, Value, ValueRef};

// #[rustr_export]
pub fn bolt_begin_internal(uri: CString, username: Vec<CString>, password: Vec<CString>) -> RResult<RPtr<Graph>> {
    let mut username = { username };
    let mut password = { password };
    if username.len() != 1 || password.len() != 1 {
        username.clear();
        password.clear();
    }
    let username = username.pop();
    let username = username.as_ref();
    let password = password.pop();
    let password = password.as_ref();
    Graph::open(&uri, username.map(CString::as_c_str), password.map(CString::as_c_str)).map(Box::new).map(RPtr::new)
}

// #[rustr_export]
pub fn bolt_query_internal(graph: RPtr<Graph>, query: CString, params: Value, as_data_frame: bool) -> RResult<RList> {
    let mut graph = { graph };
    let graph = graph.get()?;
    let result_stream = graph.query(query, params)?;
    let nfields = result_stream.nfields();
    let mut fieldnames = CharVec::alloc(nfields as _);
    for (i, f) in result_stream.fields_iter().enumerate() {
        let f = f?;
        let s = match f.to_str() {
            Ok(x) => x,
            Err(_) => stop!("Invalid UTF-8 in Neo4J field name: {:?}", f.to_bytes()),
        };
        fieldnames.set(i as _, s)?;
    }
    let results = result_stream.collect::<RResult<Vec<_>>>()?;
    if as_data_frame {
        let mut out = RList::alloc(nfields as _);
        out.set_name(&fieldnames)?;
        for y in 0..nfields {
            let mut data = RList::alloc(results.len());
            for (x, result) in results.iter().enumerate() {
                let field = result.get(y).unwrap_or(ValueRef::null());
                if !field.is_r_primitive() {
                    stop!("You must query for tabular results when using this function.");
                }
                data.set(x, field.intor()?)?;
            }
            out.set(y as _, data)?;
        }
        out.as_data_frame()?;
        Ok(out)
    } else {
        let mut out = RList::alloc(results.len() as _);
        for (x, res) in results.into_iter().enumerate() {
            let mut fields = RList::alloc(nfields as _);
            fields.set_name(&fieldnames)?;
            for (y, field) in res.into_iter().enumerate() {
                fields.set(y as _, field.intor()?)?;
            }
            out.set(x as _, fields)?;
        }
        Ok(out)
    }
}
