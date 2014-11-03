dijkstra = function(fromNode, relType, toNode, direction = "out", cost_property = character()) UseMethod("dijkstra")

dijkstra.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

dijkstra.node = function(fromNode, relType, toNode, direction = "out", cost_property = character()) {
  stopifnot(is.character(relType), 
            "node" %in% class(toNode),
            direction %in% c("in", "out"),
            is.character(cost_property))
  
  header = setHeaders()
  
  url = paste(attr(fromNode, "self"), "path", sep = "/")
  to = attr(toNode, "self")
  fields = list(to = to,
                default_cost = 1,
                relationships = list(type = relType,
                                     direction = direction),
                algorithm = "dijkstra")
  
  if(length(cost_property) > 0) {
    fields = c(fields, list(cost_property = cost_property))
  }
  
  fields = toJSON(fields)
  
  response = try(http_request(url,
                              "POST",
                              "OK",
                              postfields = fields,
                              httpheader = header),
                 silent = T)
  
  if(class(response) == "try-error") {
    message("No path found.")
    return(invisible(NULL))
  }
  
  result = fromJSON(response)
  
  class(result) = "path"
  path = configure_result(result, attr(fromNode, "username"), attr(fromNode, "password"))
  return(path)
}