pub(crate) mod bindings {
	#![allow(dead_code)]
	#![allow(non_snake_case)]
	#![allow(non_camel_case_types)]
	#![allow(non_upper_case_globals)]
	include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

	// Defined as a macro in the header
	pub fn neo4j_type(value: neo4j_value_t) -> neo4j_type_t {
		return value._type;
	}
}

extern crate rustr;

extern crate errno;

#[macro_use] pub mod utils;
pub mod value_ref;
pub use value_ref::ValueRef;
pub mod value;
pub use value::Value;
pub mod result_stream;
pub use result_stream::ResultStream;
pub mod graph;
pub use graph::Graph;

#[cfg(test)]
mod tests;
