cypher = function(graph, query, ...) UseMethod("cypher")

cypher.default = function(x, ...) {
  stop("Invalid object. Must supply graph object.")
}

cypher.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  params = list(...)
  result = cypher_endpoint(graph, query, params)
  data = result$data

  if(length(data) == 0) {
    return(invisible(NULL))
  }
  
  ### Stolen from: http://stackoverflow.com/questions/22870198/is-there-a-more-efficient-way-to-replace-null-with-na-in-a-list
  nullToNA <- function(x) {
    x[sapply(x, is.null)] = NA
    return(x)
  }
  ###
  
  data = do.call(rbind, data)
  data = nullToNA(data)
  options(stringsAsFactors = FALSE)
  df = data.frame(data)
  
  # Get the maximum length of nested lists.
  checkNested <- function(col) {
    max(unlist(sapply(col, function(x) {sapply(x, length)})))
  }
  
  # Unlist columns that aren't variable-length.
  if(all(sapply(df, class) == "list")) {
    for(i in 1:ncol(df)) {
      if(checkNested(df[i]) == 1) {
        df[i] = unlist(df[i])
      } 
    }
  }
  
  names(df) = result$columns
  row.names(df) = NULL
  return(df)
}