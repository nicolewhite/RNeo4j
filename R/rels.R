rels = function(path) UseMethod("rels")

rels.default = function(x, ...) {
  stop("Invalid object. Must supply path object.")
}

rels.path = function(path) {
  urls = attr(path, "relationships")
  header = setHeaders(path)
  FUN <- function(x) {
    url = x
    response = http_request(url, "GET", "OK", httpheader=header)
    result = fromJSON(response)
    class(result) = c("entity", "relationship")
    rel = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
    return(rel)
  }
  rels = lapply(urls, FUN)
  return(rels)
}