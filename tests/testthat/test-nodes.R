library(RNeo4j)
context("Nodes")

neo4j = startGraph("http://localhost:7474/db/data/")
clear(neo4j, input=F)

mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
nastys = createNode(neo4j, "Bar", name="Nasty's")

test_that("createNode works", {
  expect_equal(class(mugshots), "node")
  expect_equal(class(nastys), "node")
})

test_that("array properties are added correctly", {
  newNode = createNode(neo4j, "Thing", array=c(1,3,4))
  expect_identical(newNode$array, c(1,3,4))
})

test_that("properties are retrieved with correct encoding", {
  expect_equal(mugshots$location, "México")
})

test_that("getNodes works", {
  nodes = getNodes(neo4j, "MATCH n RETURN n")
  
  names = sapply(nodes, '[[', 'name')
  expect_true("Mugshots" %in% names)
  expect_true("Nasty's" %in% names)
})

test_that("getSingleNode works", {
  node = getSingleNode(neo4j, "MATCH (b:Bar {name:'Mugshots'}) RETURN b")
  expect_equal(node$location, "México")
})

test_that("getUniqueNode works", {
  addConstraint(neo4j, "Bar", "name")
  node = getUniqueNode(neo4j, "Bar", name="Mugshots")
})

test_that("getOrCreateNode works", {
  node = getOrCreateNode(neo4j, "Bar", name="Mugshots")
})