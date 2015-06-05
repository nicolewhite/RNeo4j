rels = function(path) UseMethod("rels")

rels.default = function(x, ...) {
  stop("Invalid object. Must supply path object.")
}

rels.path = function(path) {
  urls = attr(path, "relationships")

  FUN <- function(x) {
    url = x
    result = http_request(url, "GET", path)
    rel = configure_result(result, attr(path, "username"), attr(path, "password"), attr(path, "auth_token"))
    return(rel)
  }
  rels = lapply(urls, FUN)
  return(rels)
}