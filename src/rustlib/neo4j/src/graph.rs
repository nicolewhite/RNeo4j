use std::ffi::{CStr, CString};

use rustr::*;
use errno::errno;

use bindings::*;
use value::Value;
use result_stream::ResultStream;

pub struct Graph {
    ptr: *mut neo4j_connection_t,
}

impl Graph {
    pub fn open(uri: &CStr, username: Option<&CStr>, password: Option<&CStr>) -> RResult<Graph> {
        unsafe {
            let conf = neo4j_new_config();
            if let Some(username) = username {
                if neo4j_config_set_username(conf, username.as_ptr()) != 0 {
                    stop!("Failed to set username: {}", errno());
                }
            }
            if let Some(password) = password {
                if neo4j_config_set_password(conf, password.as_ptr()) != 0 {
                    stop!("Failed to set username: {}", errno());
                }
            }
            let ptr = neo4j_connect(uri.as_ptr(), conf, NEO4J_INSECURE as _);
            if ptr.is_null() {
                stop!("Failed to connect: {}", errno());
            }
            neo4j_config_free(conf);
            Ok(Graph {
                ptr: ptr,
            })
        }
    }

    pub fn query<'a>(&'a mut self, query: CString, params: Value) -> RResult<ResultStream<'a>> {
        unsafe {
            let stream = neo4j_run(self.ptr, query.as_ptr(), params.inner);
            if stream.is_null() {
                stop!("Failed to run query: {}", errno());
            }
            Ok(ResultStream::from_c_ty(stream, query, params.store))
        }
    }
}

impl Drop for Graph {
    fn drop(&mut self) {
        unsafe {
            neo4j_close(self.ptr);
        }
    }
}
