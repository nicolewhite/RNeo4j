#' Cypher Queries to Data Frames
#' 
#' Retrieve Cypher query results as a data frame.
#' 
#' If returning data, you can only query for tabular results. 
#' That is, you can't return node or relationship entities. 
#' See \code{\link{cypherToList}} for returning non-tabular data.
#' 
#' @param graph A graph object.
#' @param query A character string.
#' @param ... A named list. Parameters to pass to the query in the form key = value, if applicable.
#' 
#' @return A data.frame.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' alice = createNode(graph, "Person", name = "Alice", age = 23)
#' bob = createNode(graph, "Person", name = "Bob", age = 22)
#' charles = createNode(graph, "Person", name = "Charles", age = 25)
#' david = createNode(graph, "Person", name = "David", age = 20)
#' 
#' createRel(alice, "KNOWS", bob)
#' createRel(alice, "KNOWS", charles)
#' createRel(charles, "KNOWS", david)
#' 
#' cypher(graph, "MATCH n RETURN n.name, n.age")
#' 
#' query = "MATCH n WHERE n.age < {age} RETURN n.name, n.age"
#' cypher(graph, query, age = 24)
#' 
#' query = "MATCH n WHERE n.name IN {names} RETURN n.name, n.age"
#' names = c("Alice", "Charles")
#' cypher(graph, query, names = names)
#' 
#' query = "MATCH n WHERE n.age > {age1} AND n.age < {age2} RETURN n.name"
#' cypher(graph, query, age1=22, age2=30)
#' 
#' params = list(age1=22, age2=30)
#' cypher(graph, query, params)
#' }
#' 
#' @seealso \code{\link{cypherToList}}
#' 
#' @export
cypher = function(graph, query, ...) UseMethod("cypher")

#' @export
cypher.graph = function(graph, query, ...) {
  stopifnot(is.character(query),
            length(query) == 1)
  
  dots = list(...)
  params = parse_dots(dots)
  
  result = cypher_endpoint(graph, query, params)
  data = result$data
  
  if(length(data) == 0) {
    return(invisible())
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