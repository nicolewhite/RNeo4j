cypherToList = function(graph, query, ...) UseMethod("cypherToList")

cypherToList.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

cypherToList.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  params = list(...)
  result = cypher_endpoint(graph, query, params)
  data = result$data
  
  if(length(data) == 0) {
    return(invisible(list()))
  }
  
  response = list()
  
  for(i in 1:length(data)) {
    datum = list()
    for(j in 1:length(result$columns)) {
      name = result$columns[[j]]
      record = data[[i]][[j]]
      if(!is.null(names(record)) || !is.list(record)) {
        datum[[name]] = configure_result(record)
      } else {
        depth = length(record)
        datumdatum = list()
        for(k in 1:depth) {
          datumdatum[[k]] = configure_result(record[[k]])
        }
        datum[[name]] = datumdatum
      }
    }
    response[[i]] = datum
  }
  
  return(response)
}