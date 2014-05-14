createRel = function(fromNode, type, toNode, ...) UseMethod("createRel")

createRel.default = function(x, ...) {
  stop("Invalid object. Must supply node object.")
}

createRel.node = function(fromNode, type, toNode, ...) {
  stopifnot(is.character(type), 
            "node" %in% class(toNode))
  
  # Convert type to uppercase and replace spaces with underscores.
  type = toupper(type)
  type = gsub(" ", "_", type)
  
  props = list(...)
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = list(to = attr(toNode, "self"), type = type)
  
  # If user supplied properties, append them to request.
  if(length(props) > 0)
    fields = c(fields, data = list(props))
  
  fields = toJSON(fields)
  result = fromJSON(httpPOST(attr(fromNode, "create_relationship"), 
                                   httpheader = headers, 
                                   postfields = fields))
  
  class(result) = c("entity", "relationship")
  rel = configure_result(result)
  return(rel)
}