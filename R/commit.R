commit = function(transaction) UseMethod("commit")

commit.default = function(x) {
  stop("Invalid object. Must supply transaction object.")
}

commit.transaction = function(transaction) {
  http_request(transaction$commit,
               "POST",
               "OK")
  
  return(invisible(NULL))
}