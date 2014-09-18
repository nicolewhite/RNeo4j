updateProp = function(entity, ...) UseMethod("updateProp")

updateProp.default = function(x, ...) {
  stop("Invalid object. Must supply node or relationship object.")
}

updateProp.entity = function(entity, ...) {
  props = list(...)
  
  if(length(props) == 0)
    stop("Must supply properties to update.")
  
  header = setHeaders()
  
  for (i in 1:length(props)) {
    url = paste(attr(entity, "properties"), names(props[i]), sep = "/")
    
    if(is.character(props[[i]])) {
      field = paste0('"', props[[i]], '"')
    } else if(is.numeric(props[[i]])) {
      field = toString(props[[i]])
    } else if(is.logical(props[[i]])) {
      if(props[[i]]) {
        field = "true"
      } else {
        field = "false"
      }
    } else {
      stop("Must supply character, numeric, or logical property values.")
    }
    http_request(url,
                 "PUT",
                 "No Content",
                 field,
                 header)
    entity[names(props[i])] = props[names(props[i])]
  }
  return(entity)
}