pub(crate) mod bindings {
	#![allow(dead_code)]
	#![allow(non_snake_case)]
	#![allow(non_camel_case_types)]
	#![allow(non_upper_case_globals)]
	include!(concat!(env!("OUT_DIR"), "/bindings.rs"));
}

extern crate rustr;

extern crate errno;

#[macro_use] pub mod utils;
pub mod value;
pub use value::{Value, ValueRef};
pub mod result_stream;
pub use result_stream::ResultStream;
pub mod graph;
pub use graph::Graph;

#[cfg(test)]
mod tests;
