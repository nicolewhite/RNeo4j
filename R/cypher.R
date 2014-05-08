cypher = function(graph, query = character(), ...) UseMethod("cypher")

cypher.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

cypher.graph = function(graph, query = character(), ...) {
  stopifnot(is.character(query))
  
  params = list(...)
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = list(query = query)
  
  if(length(params) > 0)
    fields = c(fields, params = list(params))
  
  fields = toJSON(fields)
  response = fromJSON(httpPOST(graph$cypher, 
                               httpheader = headers, 
                               postfields = fields))
  
  df = do.call(rbind.data.frame, response$data)

  if (dim(df)[1] == 0 & dim(df)[2] == 0) {
    return(invisible(NULL))
    
  } else {
  names(df) = response$columns
  row.names(df) = NULL
  return(df)
  }
}