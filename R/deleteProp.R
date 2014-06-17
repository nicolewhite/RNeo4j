deleteProp = function(entity, ..., all = FALSE) UseMethod("deleteProp")

deleteProp.default = function(x, ...) {
  stop("Invalid object. Must supply node or relationship object.")
}

deleteProp.entity = function(entity, ..., all = FALSE) {
  stopifnot(is.logical(all))
  props = c(...)
  url = attr(entity, "properties")
  
  if(all) {
    http_request(url, "DELETE", "No Content")
    names(entity) = NULL
    return(entity)
    
  } else if(length(props) > 0) {
      stopifnot(is.character(props))
      urls = vapply(props, function(p) paste(url, p, sep = "/"), "")
      
      for (i in 1:length(urls)) {
        http_request(urls[[i]],
                     "DELETE",
                     "No Content")
        entity[props[i]] = NULL
      }
      return(entity)
  } else {
      stop("Must supply properties to be deleted or set all = TRUE.")
  }
}