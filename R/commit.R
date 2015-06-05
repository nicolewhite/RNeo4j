commit = function(transaction) UseMethod("commit")

commit.default = function(x) {
  stop("Invalid object. Must supply transaction object.")
}

commit.transaction = function(transaction) {
  response = http_request(transaction$commit, "POST", transaction)
  
  if(length(response$errors) > 0) {
    error = response$errors[[1]]
    stop(paste(error['code'], error['message'], sep="\n"))
  }
  
  return(invisible())
}