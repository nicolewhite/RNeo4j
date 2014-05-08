deleteProp = function(entity, ..., all = FALSE) UseMethod("deleteProp")

deleteProp.default = function(x) {
  stop("Invalid object. Must supply node or relationship object.")
}

deleteProp.entity = function(entity, ..., all = FALSE) {
  stopifnot(is.logical(all))
  
  props = c(...)
  
  if(all) {
    httpDELETE(entity$properties)
    
  } else if(length(props) > 0) {
      stopifnot(is.character(props))
      urls = vapply(props, function(x) {paste0(entity$properties, "/", x)}, "")
      lapply(urls, function(x) {httpDELETE(x)})
      
  } else {
      stop("Must supply a property to be deleted or set all = TRUE.")
  }
  
  result = fromJSON(httpGET(entity$self))
  class(result) = "entity"
  
  if("node" %in% class(entity)) {
    class(result) = c(class(result), "node")
  } else {
    class(result) = c(class(result), "relationship")
  }
  return(result)
}