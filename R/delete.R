delete = function(...) UseMethod("delete")

delete.default = function(...) {
  entities = list(...)
  classes = lapply(entities, class)
  stopifnot(all(vapply(classes, function(c) "entity" %in% c, logical(1))))
  
  headers = setHeaders(entities[[1]])
  urls = vapply(entities, function(x) (attr(x, "self")), "")
  for(i in 1:length(urls)) {
    http_request(urls[i], 
                 "DELETE", 
                 "No Content",
                 httpheader=headers)
  }
  return(invisible(NULL))
}