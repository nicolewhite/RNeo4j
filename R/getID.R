getID = function(entity) UseMethod("getID")

getID.default = function(x) {
  stop("Invalid object. Must supply a node or relationship object.")
}

getID.entity = function(entity) {
  id = as.numeric(unlist(strsplit(unlist(strsplit(attr(entity, "self"), "db/data/"))[2], "/"))[2])
  return(id)
}

