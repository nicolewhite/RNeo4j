delete = function(...) UseMethod("delete")

delete.default = function(...) {
  entities = list(...)
  # Check if all are entities.
  classes = lapply(entities, class)
  stopifnot(all(vapply(classes, function(c) "entity" %in% c, logical(1))))
  urls = vapply(entities, function(x) (attr(x, "self")), "")
  for(i in 1:length(urls)) {
    http_request(urls[i], 
                 "DELETE", 
                 "No Content")
  }
  return(invisible(NULL))
}