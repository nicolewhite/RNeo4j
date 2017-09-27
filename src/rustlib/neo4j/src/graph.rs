use std::ffi::{CStr, CString};

use rustr::*;
use errno::errno;

use bindings::*;
use value::Value;
use result_stream::ResultStream;

pub struct Graph {
    ptr: *mut neo4j_connection_t,
    pub http_url: Option<String>,
}

impl Graph {
    // could accept user and pass as &CStr, but for our purposes this is easier
    pub fn open(uri: &CStr, http_url: Option<String>, username: Option<CString>, password: Option<CString>) -> RResult<Graph> {
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
                http_url: http_url,
            })
        }
    }

    // Should this require &mut self?
    pub fn query<'a>(&'a self, query: CString, params: Value) -> RResult<ResultStream<'a>> {
        unsafe {
            let (value, store) = params.into_inner();
            let stream = neo4j_run(self.ptr, query.as_ptr(), value);
            if stream.is_null() {
                stop!("Failed to run query: {}", errno());
            }
            Ok(ResultStream::from_c_ty(stream, query, store))
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
