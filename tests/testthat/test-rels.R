library(RNeo4j)
context("Relationships")

skip_on_cran()

neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
clear(neo4j, input=F)

mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
nastys = createNode(neo4j, "Bar", name="Nasty's")
rel = createRel(mugshots, "IS_NEAR", nastys, since=2001)

test_that("createRel works", {
  expect_true("relationship" %in% class(rel))
})

test_that("getRels works", {
  r = getRels(neo4j, "MATCH ()-[r]-() RETURN r")
  x = class(r[[1]])
  expect_true("relationship" %in% x)
})

test_that("getRels works with parameters", {
  r = getRels(neo4j, "MATCH ({name:{name}})-[r]-() RETURN r", name="Mugshots")
  x = class(r[[1]])
  expect_true("relationship" %in% x)
})

test_that("getSingleRel works", {
  r = getSingleRel(neo4j, "MATCH ()-[r]-() RETURN r")
  x = class(r)
  expect_true("relationship" %in% x)
})

test_that("getSingleRel works with parameters", {
  r = getSingleRel(neo4j, "MATCH ({name:{name}})-[r]-() RETURN r", name="Mugshots")
  x = class(r)
  expect_true("relationship" %in% x)
})

test_that("startNode works", {
  n = startNode(rel)
  x = class(n)
  expect_true("node" %in% x)
  expect_identical(n, mugshots)
})

test_that("endNode works", {
  n = endNode(rel)
  x = class(n)
  expect_true("node" %in% x)
  expect_identical(n, nastys)
})

test_that("outgoingRels works", {
  r = outgoingRels(mugshots)
  x = class(r[[1]])
  expect_true("relationship" %in% x)
})

test_that("outgoingRels works with given type", {
  r = outgoingRels(mugshots, "IS_NEAR")
  x = class(r[[1]])
  expect_true("relationship" %in% x)
})

test_that("incomingRels works", {
  r = incomingRels(nastys)
  x = class(r[[1]])
  expect_true("relationship" %in% x)
})

test_that("incomingRels works with given type", {
  r = incomingRels(nastys, "IS_NEAR")
  x = class(r[[1]])
  expect_true("relationship" %in% x)
})

test_that("getType works", {
  r = createRel(mugshots, "SOMETHING", nastys)
  type = getType(r)
  expect_equal(type, "SOMETHING")
})

test_that("delete works", {
  rels = getRels(neo4j, "MATCH (:Bar {name:'Mugshots'})-[r]-() RETURN DISTINCT r")
  lapply(rels, delete)
  rels = getRels(neo4j, "MATCH (:Bar {name:'Mugshots'})-[r]-() RETURN DISTINCT r")
  expect_null(rels)
})

test_that("createRel can set properties passed as a list", {
  r = createRel(mugshots, "WHATEVER", nastys, list(prop1=1, prop2="2"))
  
  expect_equal(r$prop1, 1)
  expect_equal(r$prop2, "2")
})

test_that("you can create relationship types with spaces", {
  r = createRel(mugshots, "SPACE HERE", nastys)
  
  rels = getRels(neo4j, "MATCH ()-[r:`SPACE HERE`]-() RETURN DISTINCT r;")
  expect_equal(length(rels), 1)
})