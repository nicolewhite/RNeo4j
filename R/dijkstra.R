dijkstra = function(fromNode, relType, toNode, direction = "out", cost_property = character()) UseMethod("dijkstra")

dijkstra.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

dijkstra.node = function(fromNode, relType, toNode, cost_property, direction = "out") {
  stopifnot(is.character(relType), 
            "node" %in% class(toNode),
            direction %in% c("in", "out"),
            is.character(cost_property))
  
  header = setHeaders(fromNode)
  
  url = paste(attr(fromNode, "self"), "path", sep = "/")
  to = attr(toNode, "self")
  fields = list(to = to,
                cost_property = cost_property,
                default_cost = 1,
                relationships = list(type = relType,
                                     direction = direction),
                algorithm = "dijkstra")
  
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
  path = configure_result(result, attr(fromNode, "username"), attr(fromNode, "password"), attr(fromNode, "auth_token"))
  return(path)
}