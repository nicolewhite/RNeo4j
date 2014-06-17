addConstraint = function(graph, label, key) UseMethod("addConstraint")

addConstraint.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

addConstraint.graph = function(graph, label, key) {
  stopifnot(is.character(label), 
            is.character(key),
            length(label) == 1,
            length(key) == 1)
    
  header = setHeaders()
  fields = paste0('{\n "property_keys": [ "', key, '" ] \n}')
  url = paste(attr(graph, "constraints"), label, "uniqueness", sep = "/")
  
  http_request(url,
               "POST",
               "OK",
               postfields = fields,
               httpheader = header)
  
  return(invisible(NULL))
}