use std::ffi::{CStr, CString};
use std::marker::PhantomData;
use std::any::Any;

use rustr::*;
use value::ValueRef;
use bindings::*;
use errno::{errno, Errno};

pub struct QueryResult<'a> {
    inner: *mut neo4j_result_t,
    len: usize,
    phantom: PhantomData<&'a ()>,
}

pub struct QueryResultIter<'a> {
    inner: *mut neo4j_result_t,
    i: usize,
    len: usize,
    _dropper: Option<QueryResult<'a>>,
    phantom: PhantomData<&'a ()>,
}

impl<'a> QueryResultIter<'a> {
    fn new(res: &'a QueryResult<'a>) -> QueryResultIter<'a> {
        QueryResultIter {
            inner: res.inner,
            i: 0,
            len: res.len,
            _dropper: None,
            phantom: PhantomData,
        }
    }

    fn new_owned(res: QueryResult<'a>) -> QueryResultIter<'a> {
        QueryResultIter {
            inner: res.inner,
            i: 0,
            len: res.len,
            _dropper: Some(res),
            phantom: PhantomData,
        }
    }
}

impl<'a> Iterator for QueryResultIter<'a> {
    type Item = ValueRef<'a>;

    fn next(&mut self) -> Option<ValueRef<'a>> {
        if self.i >= self.len {
            return None;
        }
        let item = unsafe {
            Some(ValueRef::from_c_ty(neo4j_result_field(self.inner, self.i as _)))
        };
        self.i += 1;
        item
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        let left = self.len();
        (left, Some(left))
    }
}

impl<'a> ExactSizeIterator for QueryResultIter<'a> {
    fn len(&self) -> usize {
        self.len.saturating_sub(self.i)
    }
}

impl<'a> QueryResult<'a> {
    fn from_c_ty(value: *mut neo4j_result_t, len: usize) -> QueryResult<'a> {
        unsafe {
            neo4j_retain(value);
        }
        QueryResult {
            inner: value,
            len: len,
            phantom: PhantomData,
        }
    }

    pub fn len(&self) -> usize {
        self.len
    }

    pub fn get(&'a self, idx: u32) -> Option<ValueRef<'a>> {
        if idx as usize >= self.len {
            return None;
        }
        unsafe {
            Some(ValueRef::from_c_ty(neo4j_result_field(self.inner, idx)))
        }
    }

    pub fn iter(&'a self) -> QueryResultIter<'a> {
        QueryResultIter::new(self)
    }
}

impl<'a> IntoIterator for QueryResult<'a> {
    type Item = ValueRef<'a>;
    type IntoIter = QueryResultIter<'a>;

    fn into_iter(self) -> QueryResultIter<'a> {
        QueryResultIter::new_owned(self)
    }
}

impl<'a> Drop for QueryResult<'a> {
    fn drop(&mut self) {
        unsafe {
            neo4j_release(self.inner);
        }
    }
}

pub struct ResultStream<'a> {
    pub(crate) inner: *mut neo4j_result_stream_t,
    _param_store: Option<Box<Any>>,
    _query: CString,
    phantom: PhantomData<&'a ()>,
}

pub struct ResultStreamFieldIter<'a> {
    inner: *mut neo4j_result_stream_t,
    i: usize,
    phantom: PhantomData<&'a ()>,
}

impl<'a> Iterator for ResultStreamFieldIter<'a> {
    type Item = RResult<&'a CStr>;

    fn next(&mut self) -> Option<RResult<&'a CStr>> {
        unsafe {
            if self.i >= (neo4j_nfields(self.inner) as _) {
                return None;
            }
            let ptr = neo4j_fieldname(self.inner, self.i as _);
            if ptr.is_null() {
                stop!("Failed to get fieldname: {}", errno());
            }
            self.i += 1;
            Some(Ok(CStr::from_ptr(ptr)))
        }
    }
}

impl<'a> ResultStream<'a> {
    pub(crate) unsafe fn from_c_ty(value: *mut neo4j_result_stream_t, query: CString, store: Option<Box<Any>>) -> ResultStream<'a> {
        ResultStream {
            inner: value,
            phantom: PhantomData,
            _query: query,
            _param_store: store,
        }
    }

    pub fn nfields(&self) -> u32 {
        unsafe { neo4j_nfields(self.inner) }
    }

    pub fn fieldname(&self, i: u32) -> RResult<&CStr> {
        unsafe {
            if i >= self.nfields() {
                stop!("Tried to get fieldname of nonexistant field")
            }
            let ptr = neo4j_fieldname(self.inner, i);
            if ptr.is_null() {
                stop!("Failed to get fieldname: {}", errno());
            }
            Ok(CStr::from_ptr(ptr))
        }
    }

    pub fn fields_iter(&'a self) -> ResultStreamFieldIter<'a> {
        ResultStreamFieldIter {
            inner: self.inner,
            i: 0,
            phantom: PhantomData,
        }
    }
}

impl<'a> Iterator for ResultStream<'a> {
    type Item = RResult<QueryResult<'a>>;

    fn next(&mut self) -> Option<RResult<QueryResult<'a>>> {
        unsafe {
            let res = neo4j_fetch_next(self.inner);
            if res.is_null() {
                let err = neo4j_check_failure(self.inner);
                if err != 0 {
                    if err == NEO4J_STATEMENT_EVALUATION_FAILED {
                        stop!("Neo4j statement evaluation failed: {}",
                            CStr::from_ptr((*neo4j_failure_details(self.inner)).message).to_string_lossy());
                    } else {
                        stop!("Neo4j query failed: {}", Errno(err));
                    }
                }
                return None;
            }
            Some(Ok(QueryResult::from_c_ty(res, neo4j_nfields(self.inner) as _)))
        }
    }
}
