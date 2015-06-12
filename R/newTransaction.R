newTransaction = function(graph) UseMethod("newTransaction")

newTransaction.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

newTransaction.graph = function(graph) {
  url = attr(graph, "transaction")
  conf = c(global_http_config(), attr(graph, "opts"))
  
  username = attr(graph, "username")
  password = attr(graph, "password")
  
  if(!is.null(username) && !is.null(password)) {
    auth = httr::authenticate(username, password, type="basic")
    conf = c(conf, auth)
  }
  
  response = httr::POST(url, config=conf)
  header = httr::headers(response)
  content = httr::content(response)

  location = header$location
  commit = content$commit
  transaction = list(location = location, commit = commit)
  
  attr(transaction, "username") = attr(graph, "username")
  attr(transaction, "password") = attr(graph, "password")
  class(transaction) = "transaction"
  
  return(transaction)
}