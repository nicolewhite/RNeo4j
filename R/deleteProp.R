#' Delete Node and Relationship Properties
#' 
#' For a node or relationship object, delete the named properties or delete all properties.
#' 
#' @param entity A node or relationship object.
#' @param ... A character vector. The properties to delete.
#' @param all A logical constant. If \code{TRUE}, delete all properties.
#' 
#' @return A node or relationship object.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice", age = 23, status = "Married")
#' bob = createNode(graph, "Person", name = "Bob", age = 22, status = "Married")
#' charles = createNode(graph, "Person", name = "Charles", age = 25, status = "Unmarried")
#' 
#' alice = deleteProp(alice, "age")
#' bob = deleteProp(bob, c("name", "age"))
#' charles = deleteProp(charles, all = TRUE)
#' 
#' alice
#' bob
#' charles
#' }
#' 
#' @seealso \code{\link{updateProp}}
#' 
#' @export
deleteProp = function(entity, ..., all = FALSE) UseMethod("deleteProp")

#' @export
deleteProp.entity = function(entity, ..., all = FALSE) {
  stopifnot(is.logical(all))
  
  props = c(...)
  props = as.list(props)
  
  url = attr(entity, "properties")
  
  if(all) {
    http_request(url, "DELETE")
    names(entity) = NULL
    return(entity)
    
  } else if(length(props) > 0) {
      urls = lapply(props, function(p) paste(url, p, sep = "/"))
      
      for (i in 1:length(urls)) {
        http_request(urls[[i]], "DELETE")
        entity[props[[i]]] = NULL
      }
      return(entity)
  } else {
      stop("Must supply properties to be deleted or set all = TRUE.")
  }
}