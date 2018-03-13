isNode = function(obj) {
    cl = class(obj)
    return("node" %in% cl || "boltNode" %in% cl)
}