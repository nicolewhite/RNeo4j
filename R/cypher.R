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
  
  if("metadata" %in% unlist(lapply(data[[1]], names))) {
    stop("You must query for tabular results when using this function.")
  }
  
  if("length" %in% unlist(lapply(data[[1]], names))) {
    stop("You must query for tabular results when using this function.")
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
  
  # Unlist columns that aren't variable-length.
  if(all(sapply(df, class) == "list")) {
    for(i in 1:ncol(df)) {
      if(check_nested_depth(df[i]) == 1) {
        df[i] = unlist(df[i])
      } 
    }
  }
  
  names(df) = result$columns
  row.names(df) = NULL
  return(df)
}