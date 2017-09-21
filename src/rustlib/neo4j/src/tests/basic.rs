use std::ffi::CString;

use graph::Graph;
use value::Value;

#[test]
fn basic_test() {
    let cstring = CString::new("neo4j://localhost:7687").unwrap();
    let mut graph = Graph::open(&cstring, None, None).unwrap();
    graph.query(CString::new("MATCH (n:Color) DELETE n").unwrap(), Value::null()).unwrap();
}
