addIndex = function(graph, label, key) UseMethod("addIndex")

addIndex.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

addIndex.graph = function(graph, label, key) {
  stopifnot(is.character(label), is.character(key))
  
  fields = paste0('{\n "property_keys": [ \"', key, '" ] \n}')
  url = paste0(graph$root, "schema/constraint/", label, "/uniqueness")
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  httpPOST(url, httpheader = headers, postfields = fields)
  return(invisible(NULL))
}