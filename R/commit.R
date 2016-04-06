#' Transactions
#'
#' @param graph A graph object.
#' @param transaction A transaction object.
#' @param query A character string.
#' @param ... A named list. Optional parameters to pass to the query in the form key = value, if applicable.
#' 
#' @return \code{newTransaction} returns a transaction object. Both \code{appendCypher} and \code{commit} return \code{NULL}.
#' 
#' @examples 
#' \dontrun{
#' graph = startGraph("http://localhost:7474/db/data/")
#' clear(graph)
#' 
#' data = data.frame(Origin = c("SFO", "AUS", "MCI"),
#'                   FlightNum = c(1, 2, 3),
#'                  Destination = c("PDX", "MCI", "LGA"))
#' 
#' 
#' query = "
#' MERGE (origin:Airport {name:{origin_name}})
#' MERGE (destination:Airport {name:{dest_name}})
#' CREATE (origin)<-[:ORIGIN]-(:Flight {number:{flight_num}})-[:DESTINATION]->(destination)
#' "
#' 
#' t = newTransaction(graph)
#' 
#' for (i in 1:nrow(data)) {
#'   origin_name = data[i, ]$Origin
#'   dest_name = data[i, ]$Dest
#'   flight_num = data[i, ]$FlightNum
#'   
#'   appendCypher(t, 
#'                query, 
#'                origin_name = origin_name, 
#'                dest_name = dest_name, 
#'                flight_num = flight_num)
#' }
#' 
#' commit(t)
#' 
#' cypher(graph, "MATCH (o:Airport)<-[:ORIGIN]-(f:Flight)-[:DESTINATION]->(d:Airport)
#'        RETURN o.name, f.number, d.name")
#' }
#' 
#' @name transactions
NULL
#> NULL

#' @rdname transactions
#' @export
commit = function(transaction) UseMethod("commit")

#' @export
commit.transaction = function(transaction) {
  response = http_request(transaction$commit, "POST")
  
  if(length(response$errors) > 0) {
    error = response$errors[[1]]
    stop(paste(error['code'], error['message'], sep="\n"))
  }
  
  return(invisible())
}