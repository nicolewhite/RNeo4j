library(RNeo4j)
context("Cypher To List")

skip_on_cran()

if (!is.na(Sys.getenv("NEO4J_BOLT", NA))) {
  neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password", boltUri = "neo4j://localhost:7687")
} else {
  neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
}
importSample(neo4j, "movies", input=F)

test_that("single property is retrieved", {
  query = "MATCH (p:Person) RETURN p.name LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true(is.character(response[[1]]$p.name))
  expect_equal(length(response), 5)
})

test_that("multiple properties are retrieved", {
  query = "MATCH (p:Person) RETURN p.name, p.born LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true(is.character(response[[1]]$p.name))
  expect_true(is.numeric(response[[1]]$p.born))
  expect_equal(length(response), 5)
})

test_that("nodes and properties are retrieved", {
  query = "MATCH (p:Person) RETURN p, p.name LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$p))
  expect_true(is.character(response[[1]]$p.name))
  expect_equal(length(response), 5)
})

test_that("relationships and properties are retrieved", {
  skip_on_bolt(neo4j, "relationships")
  query = "MATCH (:Person)-[r:ACTED_IN]->(m:Movie) RETURN r, m.title LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("relationship" %in% class(response[[1]]$r))
  expect_true(is.character(response[[1]]$m.title))
  expect_equal(length(response), 5)
})

test_that("nodes and relationships are retrieved", {
  skip_on_bolt(neo4j, "relationships")
  query = "MATCH (p:Person)-[r:ACTED_IN]->(:Movie) RETURN p, r LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$p))
  expect_true("relationship" %in% class(response[[1]]$r))
  expect_equal(length(response), 5)
})

test_that("paths and properties are retrieved", {
  skip_on_bolt(neo4j, "paths")
  query = "MATCH x = (p:Person)-[:ACTED_IN]->(:Movie) RETURN x, p.name LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_equal(class(response[[1]]$x), "path")
  expect_true(is.character(response[[1]]$p.name))
  expect_equal(length(response), 5)
})

test_that("paths and nodes are retrieved", {
  skip_on_bolt(neo4j, "paths")
  query = "MATCH x = (p:Person)-[:ACTED_IN]->(:Movie) RETURN x, p LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_equal(class(response[[1]]$x), "path")
  expect_true("node" %in% class(response[[1]]$p))
  expect_equal(length(response), 5)
})

test_that("paths and relationships are retrieved", {
  skip_on_bolt(neo4j, "paths or relationships")
  query = "MATCH x = (:Person)-[r:ACTED_IN]->(:Movie) RETURN x, r LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_equal(class(response[[1]]$x), "path")
  expect_true("relationship" %in% class(response[[1]]$r))
  expect_equal(length(response), 5)
})

test_that("collections of properties are retrieved", {
  query = "
  MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
  RETURN m, COLLECT(p.name) AS actors
  LIMIT 5
  "
  
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$m))
  expect_true(is.list(response[[1]]$actors))
  expect_equal(length(response), 5)
})

test_that("collections of nodes are retrieved", {
  query = "MATCH (p:Person)-[:ACTED_IN]->(m:Movie) RETURN p, COLLECT(m) AS movies LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$p))
  expect_true(is.list(response[[1]]$movies))
  expect_true("node" %in% class(response[[1]]$movies[[1]]))
})

test_that("it works with parameters", {
  query = "
  MATCH (n) RETURN n LIMIT {limit}
  "
  
  response = cypherToList(neo4j, query, limit=5)
  expect_equal(length(response), 5)
})

test_that("it works with multiple parameters", {
  query = "
  MATCH (n) RETURN n SKIP {skip} LIMIT {limit}
  "
  
  response = cypherToList(neo4j, query, limit=5, skip=5)
  expect_equal(length(response), 5)
})

test_that("it works with a list of parameters", {
  query = "
  MATCH (n) RETURN n SKIP {skip} LIMIT {limit}
  "
  
  response = cypherToList(neo4j, query, list(limit=5, skip=5))
  expect_equal(length(response), 5)
})

test_that("it can return nodes with empty collections as properties", {
  clear(neo4j, input=F)
  
  cypherToList(neo4j, 'CREATE (n:test {a:[]})')
  n = cypherToList(neo4j, 'MATCH (n:test {a:[]}) RETURN n')
  n = n[[1]]$n
  
  expect_equal(length(n$a), 0)
})

test_that("it can return empty collections", {
  clear(neo4j, input=F)
  
  query = "RETURN [] AS col"
  response = cypherToList(neo4j, query)[[1]]
  
  expect_equal(response$col, list())
})

test_that("it can return empty collections along with a value", {
  clear(neo4j, input=F)
  
  query = "RETURN [] AS col, 5 AS five"
  response = cypherToList(neo4j, query)[[1]]
  
  expect_equal(response$col, list())
  expect_equal(response$five, 5)
})

test_that("it can return empty collections and non-empty collections", {
  clear(neo4j, input=F)
  
  query = "RETURN [] AS col1, [5,6] AS col2"
  response = cypherToList(neo4j, query)[[1]]
  
  expect_equal(response$col1, list())
  expect_equal(response$col2, list(5,6))
})