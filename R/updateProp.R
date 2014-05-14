updateProp = function(entity, ...) UseMethod("updateProp")

updateProp.default = function(x, ...) {
  stop("Invalid object. Must supply node or relationship object.")
}

updateProp.entity = function(entity, ...) {
  props = list(...)
  
  if(length(props) == 0)
    stop("Must supply properties to update.")
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  
  for (i in 1:length(props)) {
    url = paste0(attr(entity, "properties"), "/", names(props[i]))
    field = ifelse(is.character(props[[i]]), paste0('"', props[[i]], '"'), toString(props[[i]]))
    httpPUT(url, httpheader = headers, postfields = field)
    entity[names(props[i])] = props[names(props[i])]
  }
  
  return(entity)
}