#' @rdname transactions
#' @export
newTransaction = function(graph) UseMethod("newTransaction")

#' @export
newTransaction.graph = function(graph) {
  httr::set_config(httr::user_agent(paste("RNeo4j", version(), sep="/")))
  opts = c(attr(graph, "opts"), ssl_verifypeer = 0)
  
  username = attr(graph, "username")
  password = attr(graph, "password")
  
  if(!is.null(username) && !is.null(password)) {
    auth = httr::authenticate(username, password, type="basic")
    httr::set_config(auth)
  }
  
  url = attr(graph, "transaction")
  response = httr::POST(url, httr::config(opts))
  header = httr::headers(response)
  content = httr::content(response)

  location = header$location
  commit = content$commit
  transaction = list(location = location, commit = commit)
  
  attr(transaction, "username") = username
  attr(transaction, "password") = password
  class(transaction) = "transaction"
  
  return(transaction)
}