cypher = function(graph, query, ...) UseMethod("cypher")

cypher.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

cypher.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  params = list(...)
  
  headers = list('Accept' = 'application/json', 'Content-Type' = 'application/json')
  fields = list(query = query)
  
  # If parameters are supplied, add them to http request.
  if(length(params) > 0)
    fields = c(fields, params = list(params))
  
  fields = toJSON(fields)
  response = fromJSON(httpPOST(attr(graph, "cypher"), 
                               httpheader = headers, 
                               postfields = fields))
  
  data = response$data
  
  replaceNULL = function(row) {
    new = lapply(row, function(r) ifelse(is.null(r), NA, r))
    return(new)
  }
  
  data = lapply(data, replaceNULL)
  
  options(stringsAsFactors = FALSE)
  
  df = do.call(rbind.data.frame, data)
  
  if (is.empty(df)) {
    message("Cypher executed, but did not return any results.")
    return(invisible(NULL))
  } 
  
  names(df) = response$columns
  row.names(df) = NULL
  return(df)
}