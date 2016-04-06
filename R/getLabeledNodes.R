#' Retrieve Nodes by Label and Property
#' 
#' Retrieve nodes from the graph with the specified label and optional key = value pair.
#' 
#' @param graph A graph object.
#' @param .label A character string.
#' @param ... A named list. A key = value pair to search the labeled nodes.
#' 
#' @return A list of node objects.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' createNode(graph, "School", name = "University of Texas at Austin")
#' createNode(graph, "School", name = "Louisiana State University")
#' 
#' createNode(graph, "Person", name = "Nicole", status = "Employed")
#' createNode(graph, "Person", name = "Drew", status = "Employed")
#' createNode(graph, "Person", name = "Aaron", status = "Unemployed")
#' 
#' schools = getLabeledNodes(graph, "School")
#' 
#' sapply(schools, function(s) s$name)
#' 
#' employed_people = getLabeledNodes(graph, "Person", status = "Employed")
#' 
#' sapply(employed_people, function(p) p$name)
#' }
#' 
#' @seealso \code{\link{getUniqueNode}}
#' 
#' @export
getLabeledNodes = function(graph, .label, ...) UseMethod("getLabeledNodes")

#' @export
getLabeledNodes.graph = function(graph, .label, ...) {
  stopifnot(is.character(.label))

  url = paste(attr(graph, "root"), "label", .label, "nodes", sep = "/")
  param = c(...)
  
  if(length(param) > 1)
    stop("Can only search by one property.")

  if(length(param) == 1) {
    url = paste0(url, "?", names(param), "=")
    
    if(is.character(param[[1]])) {
      param[[1]] = URLencode(param[[1]], reserved = TRUE)
      url = paste0(url, "%22", param[[1]], "%22")
    } else if(is.numeric(param[[1]])) {
      url = paste0(url, param[[1]])
    } else if(is.logical(param[[1]])) {
      if(param[[1]]) {
        url = paste0(url, "true")
      } else {
        url = paste0(url, "false")
      }
    } else {
      stop("Property value must be character, numeric, or logical.")
    }
  }

  result = http_request(url, "GET")

  if(length(result) == 0) {
    return(invisible())
  }
  
  nodes = lapply(result, function(r) configure_result(r))
  return(nodes)
}
