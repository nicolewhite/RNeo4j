#' @rdname transactions
#' @export
appendCypher = function(transaction, query, ...) UseMethod("appendCypher")

#' @export
appendCypher.transaction = function(transaction, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  url = transaction$location
  dots = list(...)
  params = parse_dots(dots)
  
  if(length(params) > 0) {
    fields = list(statements = list(list(statement=query, parameters=params)))
  } else {
    fields = list(statements = list(list(statement=query)))
  }
  
  response = http_request(url, "POST", fields)
  
  if(length(response$errors) > 0) {
    error = response$errors[[1]]
    stop(paste(error['code'], error['message'], sep="\n"))
  }
  
  return(invisible())
}