library(RNeo4j)
context("Cypher To List")

skip_on_cran()

neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
importSample(neo4j, "tweets", input=F)

test_that("single property is retrieved", {
  query = "MATCH (u:User) RETURN u.screen_name LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true(is.character(response[[1]]$u.screen_name))
  expect_equal(length(response), 5)
})

test_that("multiple properties are retrieved", {
  query = "MATCH (u:User) RETURN u.name, u.screen_name LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true(is.character(response[[1]]$u.name))
  expect_true(is.character(response[[1]]$u.screen_name))
  expect_equal(length(response), 5)
})

test_that("nodes and properties are retrieved", {
  query = "MATCH (u:User) RETURN u, u.name LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$u))
  expect_true(is.character(response[[1]]$u.name))
  expect_equal(length(response), 5)
})

test_that("relationships and properties are retrieved", {
  query = "MATCH (:User)-[r:POSTS]->(t:Tweet) RETURN r, t.text LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("relationship" %in% class(response[[1]]$r))
  expect_true(is.character(response[[1]]$t.text))
  expect_equal(length(response), 5)
})

test_that("nodes and relationships are retrieved", {
  query = "MATCH (u:User)-[r:POSTS]->(:Tweet) RETURN u, r LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$u))
  expect_true("relationship" %in% class(response[[1]]$r))
  expect_equal(length(response), 5)
})

test_that("paths and properties are retrieved", {
  query = "MATCH p = (u:User)-[:POSTS]->(:Tweet) RETURN p, u.name LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_equal(class(response[[1]]$p), "path")
  expect_true(is.character(response[[1]]$u.name))
  expect_equal(length(response), 5)
})

test_that("paths and nodes are retrieved", {
  query = "MATCH p = (u:User)-[:POSTS]->(:Tweet) RETURN p, u LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_equal(class(response[[1]]$p), "path")
  expect_true("node" %in% class(response[[1]]$u))
  expect_equal(length(response), 5)
})

test_that("paths and relationships are retrieved", {
  query = "MATCH p = (:User)-[r:POSTS]->(:Tweet) RETURN p, r LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_equal(class(response[[1]]$p), "path")
  expect_true("relationship" %in% class(response[[1]]$r))
  expect_equal(length(response), 5)
})

test_that("collections of properties are retrieved", {
  query = "
  MATCH (u:User)-[:POSTS]->(t:Tweet) 
  WITH u, COUNT(t) AS count, COLLECT(t.text) AS tweets
  WHERE count > 1
  RETURN u, tweets
  LIMIT 5
  "
  
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$u))
  expect_true(is.list(response[[1]]$tweets))
  expect_equal(length(response), 5)
})

test_that("collections of nodes are retrieved", {
  query = "MATCH (u:User)-[:POSTS]->(t:Tweet) RETURN u, COLLECT(t) AS tweets LIMIT 5"
  response = cypherToList(neo4j, query)
  
  expect_true("node" %in% class(response[[1]]$u))
  expect_true(is.list(response[[1]]$tweets))
  expect_true("node" %in% class(response[[1]]$tweets[[1]]))
})

test_that("it works with parameters", {
  query = "
  MATCH n RETURN n LIMIT {limit}
  "
  
  response = cypherToList(neo4j, query, limit=5)
  expect_equal(length(response), 5)
})

test_that("it works with multiple parameters", {
  query = "
  MATCH n RETURN n SKIP {skip} LIMIT {limit}
  "
  
  response = cypherToList(neo4j, query, limit=5, skip=5)
  expect_equal(length(response), 5)
})

test_that("it works with a list of parameters", {
  query = "
  MATCH n RETURN n SKIP {skip} LIMIT {limit}
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