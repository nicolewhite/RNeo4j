deleteProp = function(entity, ..., all = FALSE) UseMethod("deleteProp")

deleteProp.default = function(x, ...) {
  stop("Invalid object. Must supply node or relationship object.")
}

deleteProp.entity = function(entity, ..., all = FALSE) {
  stopifnot(is.logical(all))
  
  props = c(...)
  props = as.list(props)
  
  url = attr(entity, "properties")
  
  if(all) {
    http_request(url, "DELETE", entity)
    names(entity) = NULL
    return(entity)
    
  } else if(length(props) > 0) {
      urls = lapply(props, function(p) paste(url, p, sep = "/"))
      
      for (i in 1:length(urls)) {
        http_request(urls[[i]], "DELETE", entity)
        entity[props[[i]]] = NULL
      }
      return(entity)
  } else {
      stop("Must supply properties to be deleted or set all = TRUE.")
  }
}