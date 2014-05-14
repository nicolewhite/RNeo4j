deleteProp = function(entity, ..., all = FALSE) UseMethod("deleteProp")

deleteProp.default = function(x, ...) {
  stop("Invalid object. Must supply node or relationship object.")
}

deleteProp.entity = function(entity, ..., all = FALSE) {
  stopifnot(is.logical(all))
  
  props = c(...)
  
  if(all) {
    httpDELETE(attr(entity, "properties"))
    
  } else if(length(props) > 0) {
      stopifnot(is.character(props))
      urls = vapply(props, function(x) {paste0(attr(entity, "properties"), "/", x)}, "")
      lapply(urls, function(x) {httpDELETE(x)})
      
      for (i in 1:length(props)) {
        entity[props[i]] = NULL
      }
      
      return(entity)
      
  } else {
      stop("Must supply a property to be deleted or set all = TRUE.")
  }
}