allShortestPaths = function(fromNode, relType, toNode, direction = "out", max_depth = 1) UseMethod("allShortestPaths")

allShortestPaths.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

allShortestPaths.node = function(fromNode, relType, toNode, direction = "out", max_depth = 1) {
  stopifnot(is.character(relType), 
            "node" %in% class(toNode),
            direction %in% c("in", "out"),
            is.numeric(max_depth))
  
  header = setHeaders(fromNode)
  
  url = paste(attr(fromNode, "self"), "paths", sep = "/")
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
  
  if(length(result) == 0) {
    return(invisible(NULL))
  }
  
  set_class = function(r) {
    class(r) = "path"
    return(r)
  }
  
  result = lapply(result, set_class)
  paths = lapply(result, function(r) configure_result(r, attr(fromNode, "username"), attr(fromNode, "password"), attr(fromNode, "auth_token")))
  return(paths)
}