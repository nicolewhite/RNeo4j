library(RNeo4j)
context("Relationships")

neo4j = startGraph("http://localhost:7474/db/data/")
clear(neo4j, input=F)

mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
nastys = createNode(neo4j, "Bar", name="Nasty's")
rel = createRel(mugshots, "IS_NEAR", nastys, since=2001)

test_that("createRel works", {
  expect_equal(class(rel), "relationship")
})

test_that("array propertied are added correctly", {
  newRel = createRel(mugshots, "SOMETHING", nastys, array=c(1,3,4))
  expect_identical(newRel$array, c(1,3,4))
})

test_that("getRels works", {
  r = getRels(neo4j, "MATCH ()-[r]-() RETURN r")
  x = sapply(r, class)
  expect_true(all(x == "relationship"))
})

test_that("getRels works with parameters", {
  r = getRels(neo4j, "MATCH ({name:{name}})-[r]-() RETURN r", name="Mugshots")
  x = sapply(r, class)
  expect_true(all(x == "relationship"))
})

test_that("getSingleRel works", {
  r = getSingleRel(neo4j, "MATCH ()-[r]-() RETURN r")
  expect_equal(class(r), "relationship")
})

test_that("getSingleRel works with parameters", {
  r = getSingleRel(neo4j, "MATCH ({name:{name}})-[r]-() RETURN r", name="Mugshots")
  expect_equal(class(r), "relationship")
})

test_that("startNode works", {
  n = startNode(rel)
  expect_equal(class(n), "node")
  expect_identical(n, mugshots)
})

test_that("endNode works", {
  n = endNode(rel)
  expect_equal(class(n), "node")
  expect_identical(n, nastys)
})

test_that("outgoingRels works", {
  r = outgoingRels(mugshots)
  x = sapply(r, class)
  expect_true(all(x == "relationship"))
})

test_that("outgoingRels works with given type", {
  r = outgoingRels(mugshots, "SOMETHING")
  x = sapply(r, class)
  expect_true(all(x == "relationship"))
})

test_that("incomingRels works", {
  r = incomingRels(nastys)
  x = sapply(r, class)
  expect_true(all(x == "relationship"))
})

test_that("incomingRels works with given type", {
  r = incomingRels(nastys, "SOMETHING")
  x = sapply(r, class)
  expect_true(all(x == "relationship"))
})