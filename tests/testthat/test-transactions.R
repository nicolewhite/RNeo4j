library(RNeo4j)
context("Transactions")

skip_on_cran()

neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
clear(neo4j, input=F)

test_that("transactions work", {
  actual = data.frame(Origin = c("SFO", "AUS", "MCI"),
                      FlightNum = c(1, 2, 3),
                      Destination = c("PDX", "MCI", "LGA"))
  
  query = "
  MERGE (origin:Airport {name:{origin_name}})
  MERGE (destination:Airport {name:{dest_name}})
  CREATE (origin)<-[:ORIGIN]-(:Flight {number:{flight_num}})-[:DESTINATION]->(destination)
  "

  t = newTransaction(neo4j)
  
  for (i in 1:nrow(actual)) {
    origin_name = actual[i, ]$Origin
    dest_name = actual[i, ]$Dest
    flight_num = actual[i, ]$FlightNum
    
    appendCypher(t, 
                 query, 
                 origin_name = origin_name, 
                 dest_name = dest_name, 
                 flight_num = flight_num)
  }
  
  commit(t)
  
  q = "
  MATCH (o:Airport)<-[:ORIGIN]-(f:Flight)-[:DESTINATION]->(d:Airport)
  RETURN o.name AS Origin, f.number AS FlightNum, d.name AS Destination
  ORDER BY FlightNum
  "
  
  expected = cypher(neo4j, q)
  
  expect_equal(actual, expected)
})

clear(neo4j, input=F)

test_that("appendCypher works with a list of parameters", {
  actual = data.frame(Origin = c("SFO", "AUS", "MCI"),
                      FlightNum = c(1, 2, 3),
                      Destination = c("PDX", "MCI", "LGA"))
  
  query = "
  MERGE (origin:Airport {name:{origin_name}})
  MERGE (destination:Airport {name:{dest_name}})
  CREATE (origin)<-[:ORIGIN]-(:Flight {number:{flight_num}})-[:DESTINATION]->(destination)
  "
  
  t = newTransaction(neo4j)
  
  for (i in 1:nrow(actual)) {
    origin_name = actual[i, ]$Origin
    dest_name = actual[i, ]$Dest
    flight_num = actual[i, ]$FlightNum
    
    appendCypher(t, 
                 query, 
                 list(origin_name = origin_name, 
                 dest_name = dest_name, 
                 flight_num = flight_num))
  }
  
  commit(t)
  
  q = "
  MATCH (o:Airport)<-[:ORIGIN]-(f:Flight)-[:DESTINATION]->(d:Airport)
  RETURN o.name AS Origin, f.number AS FlightNum, d.name AS Destination
  ORDER BY FlightNum
  "
  
  expected = cypher(neo4j, q)
  
  expect_equal(actual, expected)
})