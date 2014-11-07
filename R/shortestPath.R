shortestPath = function(fromNode, relType, toNode, direction = "out", max_depth = 1) UseMethod("shortestPath")

shortestPath.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

shortestPath.node = function(fromNode, relType, toNode, direction = "out", max_depth = 1) {
  stopifnot(is.character(relType), 
            "node" %in% class(toNode),
            direction %in% c("in", "out"),
            is.numeric(max_depth))
  
  header = setHeaders()
  
  url = paste(attr(fromNode, "self"), "path", sep = "/")
  to = attr(toNode, "self")
  fields = list(to = to,
                max_depth = max_depth,
                relationships = list(type = relType,
                                     direction = direction),
                algorithm = "shortestPath")
  
  fields = toJSON(fields)
  
  response = try(http_request(url,
                          "POST",
                          "OK",
                          postfields = fields,
                          httpheader = header),
                 silent = T)
  
  if(class(response) == "try-error") {
    return(invisible(NULL))
  }
  
  result = fromJSON(response)
  
  class(result) = "path"
  path = configure_result(result, attr(fromNode, "username"), attr(fromNode, "password"))
  return(path)
}