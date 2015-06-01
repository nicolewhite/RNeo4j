library(RNeo4j)
context("Paths")

neo4j = startGraph("http://localhost:7474/db/data/")
clear(neo4j, input=F)

alice = createNode(neo4j, "Person", name = "Alice")
bob = createNode(neo4j, "Person", name = "Bob")
charles = createNode(neo4j, "Person", name = "Charles")
david = createNode(neo4j, "Person", name = "David")
elaine = createNode(neo4j, "Person", name = "Elaine")

r1 = createRel(alice, "WORKS_WITH", bob, weight=1.5)
r2 = createRel(bob, "WORKS_WITH", charles, weight=2)
r3 = createRel(bob, "WORKS_WITH", david, weight=4)
r4 = createRel(charles, "WORKS_WITH", david, weight=1)
r5 = createRel(alice, "WORKS_WITH", elaine, weight=2)
r6 = createRel(elaine, "WORKS_WITH", david, weight=2.5)

test_that("shortestPath returns null when not found", {
  p = shortestPath(alice, "WORKS_WITH", david)
  expect_null(p)
  
  p = shortestPath(alice, "WORKS_WITH", david, direction = "in", max_depth = 4)
  expect_null(p)
})

test_that("shortestPath works", {
  p = shortestPath(alice, "WORKS_WITH", david, max_depth=4)
  expect_is(p, "path")
  expect_equal(p$length, 2)
  
  n = nodes(p)
  actual_names = sapply(n, '[[', 'name')
  expected_names = c("Alice", "Bob", "David")
  expect_equal(actual_names, expected_names)
  
  p = shortestPath(david, "WORKS_WITH", alice, direction = "in", max_depth = 4)
  expect_is(p, "path")
  expect_equal(p$length, 2)
  
  n = nodes(p)
  actual_names = sapply(n, '[[', 'name')
  expected_names = c("David", "Bob", "Alice")
  expect_equal(actual_names, expected_names)
})

test_that("allShortestPaths returns null when not found", {
  p = allShortestPaths(alice, "WORKS_WITH", david)
  expect_null(p)
  
  p = allShortestPaths(alice, "WORKS_WITH", david, direction = "in", max_depth = 4)
  expect_null(p)
})

test_that("allShortestPaths works", {
  p = allShortestPaths(alice, "WORKS_WITH", david, max_depth = 4)
  expect_is(p, "list")
  expect_is(p[[1]], "path")
  expect_equal(length(p), 2)
  
  p = allShortestPaths(david, "WORKS_WITH", alice, direction = "in", max_depth = 4)
  expect_is(p, "list")
  expect_is(p[[1]], "path")
  expect_equal(length(p), 2)
})

test_that("getPaths returns null when not found", {
  query = "
  MATCH p = (:Thing)--(:Thing)
  RETURN p
  "
  p = getPaths(neo4j, query)
  expect_null(p)
})

test_that("getPaths throws error when returning a non-path object", {
  query = "MATCH n RETURN n"
  expect_error(getPaths(neo4j, query))
})

test_that("getPaths works", {
  query = "
  MATCH p = (:Person {name:'Alice'})-[:WORKS_WITH*1..4]->(:Person {name:'David'})
  RETURN p
  "
  p = getPaths(neo4j, query)
  
  expect_equal(length(p), 3)
  expect_is(p, "list")
  expect_is(p[[1]], "path")
  
  starts = lapply(p, startNode)
  actual_names = sapply(starts, '[[', 'name')
  expected_names = rep("Alice", 3)
  expect_equal(actual_names, expected_names)
  
  ends = lapply(p, endNode)
  actual_names = sapply(ends, '[[', 'name')
  expected_names = rep("David", 3)
  expect_equal(actual_names, expected_names)
})

test_that("dijkstra works", {
  p = dijkstra(alice, "WORKS_WITH", david, cost_property="weight")
  
  expect_equal(p$weight, 4.5)
  expect_equal(p$length, 2)
})

test_that("dijkstra returns null when not found", {
  p = dijkstra(alice, "WORKS_WITH", david, cost_property="weight", direction="in")
  
  expect_null(p)
})

test_that("allDijkstra works", {
  p = allDijkstra(alice, "WORKS_WITH", david, cost_property="weight")
  
  expect_equal(p[[1]]$weight, 4.5)
  expect_equal(p[[2]]$weight, 4.5)
})

test_that("allDijkstra returns null when not found", {
  p = allDijkstra(alice, "WORKS_WITH", david, cost_property="weight", direction="in")
  
  expect_null(p)
})