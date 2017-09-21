#[macro_export]
macro_rules! stop {
    ($($x:tt)*) => {
        return Err(::rustr::error::RError::forcestop(format!($( $x )*))).into();
    };
}
