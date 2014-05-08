delete = function(object, ...) UseMethod("delete")

delete.default = function(x) {
  stop("Invalid object. Must supply node or relationship object(s).")
}

delete.entity = function(entity, ...) {
  entities = list(entity, ...)
  urls = vapply(entities, function(x) {(x$self)}, "")
  lapply(urls, function(x) {httpDELETE(x)})
  return(invisible(NULL))
}