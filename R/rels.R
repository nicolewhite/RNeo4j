rels = function(path) UseMethod("rels")

rels.default = function(x, ...) {
  stop("Invalid object. Must supply path object.")
}

rels.path = function(path) {
  urls = attr(path, "relationships")
  FUN <- function(x) {
    url = x
    response = http_request(url, "GET", "OK")
    result = fromJSON(response)
    class(result) = c("entity", "relationship")
    rel = configure_result(result, attr(path, "username"), attr(path, "password"))
    return(rel)
  }
  rels = lapply(urls, FUN)
  return(rels)
}