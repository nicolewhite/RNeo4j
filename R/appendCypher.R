appendCypher = function(transaction, query, ...) UseMethod("appendCypher")

appendCypher.default = function(x) {
  stop("Invalid object. Must supply transaction object.")
}

appendCypher.transaction = function(transaction, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  url = transaction$location
  header = setHeaders(transaction)
  params = list(...)
  fields = list(statement = query)
  
  if(length(params) > 0) {
    fields = c(fields, parameters = list(params))
    max_digits = find_max_dig(params)
  }
  
  postfields = paste0("{\"statements\":[", toJSON(fields, digits = max_digits), "]}")
  
  response = http_request(url,
                          "POST",
                          "OK",
                          postfields = postfields,
                          httpheader = header)
  
  response = fromJSON(response)
  
  if(length(response$errors) > 0) {
    error = response$errors[[1]]
    stop(paste(error['code'], error['message']))
  }
  
  return(invisible(NULL))
}