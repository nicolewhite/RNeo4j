createRel = function(.fromNode, .relType, .toNode, ...) {
  UseMethod("createRel")
}

createRel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

createRel.node = function(.fromNode, .relType, .toNode, ...) {
  stopifnot(is.character(.relType), 
            "node" %in% class(.toNode))
  
  if(length(grep(" ", .relType)) > 0) {
    stop("Cannot have spaces in relationship types. Use UNDER_SCORES instead.")
  }
  
  fields = list(to = attr(.toNode, "self"), type = .relType)
  dots = list(...)
  params = parse_dots(dots)
  
  if(length(params) > 0) {
    fields = c(fields, data = list(params)) 
  }
    
  url = attr(.fromNode, "create_relationship")
  result = http_request(url,
                        "POST",
                        .fromNode,
                        fields)

  rel = configure_result(result, attr(.fromNode, "username"), attr(.fromNode, "password"), attr(.fromNode, "auth_token"))
  return(rel)
}