updateProp = function(entity, ...) UseMethod("updateProp")

updateProp.default = function(x, ...) {
  stop("Invalid object. Must supply node or relationship object.")
}

updateProp.entity = function(entity, ...) {
  props = list(...)
  
  if(length(props) == 0)
    stop("Must supply properties to update.")
  
  for (i in 1:length(props)) {
    key = names(props[i])
    value = props[[i]]
    url = paste(attr(entity, "properties"), key, sep = "/")
    http_request(url, "PUT", entity, value)
    entity[key] = props[key]
  }
  
  return(entity)
}