createRel = function(fromNode, type, toNode, ...) UseMethod("createRel")

createRel.default = function(x) {
  stop("Invalid object. Must supply node object.")
}

createRel.node = function(fromNode, type, toNode, ...) {
  stopifnot(is.character(type), 
            "node" %in% class(toNode))
  
  props = list(...)
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = list(to = toNode$self, type = type)
  
  if(length(props) > 0)
    fields = c(fields, data = list(props))
  
  fields = toJSON(fields)
  relationship = fromJSON(httpPOST(fromNode$create_relationship, 
                                   httpheader = headers, 
                                   postfields = fields))
  
  class(relationship) = c("entity", "relationship")
  return(relationship)
}