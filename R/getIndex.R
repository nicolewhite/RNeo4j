getIndex = function(graph, ...) UseMethod("getIndex")

getIndex.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

getIndex.graph = function(graph, label = character()) {
  stopifnot(is.character(label))
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  url = paste0(graph$root, "schema/constraint")
  
  if(length(label) > 0)
    url = paste0(url, "/", label, "/uniqueness")
    
  response = fromJSON(httpGET(url, httpheader = headers))

  if(length(response) == 0) {
    message("No indices.")
    return(invisible(NULL))
  }
    
  keys = do.call(rbind.data.frame, response)
  rownames(keys) = NULL
  return(keys[-3])
}