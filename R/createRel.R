createRel = function(fromNode, type, toNode, ...) UseMethod("createRel")

createRel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

createRel.node = function(fromNode, type, toNode, ...) {
  stopifnot(is.character(type), 
            "node" %in% class(toNode))
  
  if(length(grep(" ", type)) > 0) {
    stop("Cannot have spaces in relationship types. Use UNDER_SCORES instead.")
  }
  
  props = list(...)
  header = setHeaders()
  
  fields = list(to = attr(toNode, "self"), type = type)
  
  # If user supplied properties, append them to request.
  if(length(props) > 0)
    fields = c(fields, data = list(props))
  
  fields = toJSON(fields)
  url = attr(fromNode, "create_relationship")
  response = http_request(url,
                          "POST",
                          "Created",
                          postfields = fields,
                          httpheader = header)

  result = fromJSON(response)
  class(result) = c("entity", "relationship")
  rel = configure_result(result)
  return(rel)
}