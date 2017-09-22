skip_on_bolt = function(graph, feature) {
  if ("boltGraph" %in% class(graph)) {
    skip(paste("Rust Bolt interface doesn't support", feature, "yet", sep=" "))
  }
}