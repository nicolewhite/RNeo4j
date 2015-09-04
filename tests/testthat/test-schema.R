library(RNeo4j)
context("Schema")

skip_on_cran()

neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")

test_that("addConstraint fails on data that violates the constraint", {
  clear(neo4j, input=F)
  createNode(neo4j, "Person", name="Alice")
  createNode(neo4j, "Person", name="Alice")
  expect_error(addConstraint(neo4j, "Person", "name"))
})

test_that("adding a node that violates a constraint fails", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Person", "name")
  createNode(neo4j, "Person", name="Alice")
  expect_error(createNode(neo4j, "Person", name="Alice"))
})

test_that("adding an index when a constraint already exists fails", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Person", "name")
  expect_error(addIndex(neo4j, "Person", "name"))
})

test_that("adding a constraint when an index already exists fails", {
  clear(neo4j, input=F)
  addIndex(neo4j, "Person", "name")
  expect_error(addConstraint(neo4j, "Person", "name"))
})

test_that("addIndex and getIndex work", {
  clear(neo4j, input=F)
  addIndex(neo4j, "Person", "name")
  index1 = getIndex(neo4j)
  index2 = getIndex(neo4j, "Person")
  expect_true("Person" %in% index1$label)
  expect_true("Person" %in% index2$label)
  expect_true("name" %in% index1$property_keys)
  expect_true("name" %in% index2$property_keys)
})

test_that("addConstraint and getConstraint work", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Person", "name")
  const1 = getConstraint(neo4j)
  const2 = getConstraint(neo4j, "Person")
  expect_true("Person" %in% const1$label)
  expect_true("Person" %in% const2$label)
  expect_true("name" %in% const1$property_keys)
  expect_true("name" %in% const2$property_keys)
})

test_that("addConstraint also adds an index", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Person", "name")
  index1 = getIndex(neo4j)
  index2 = getIndex(neo4j, "Person")
  expect_true("Person" %in% index1$label)
  expect_true("Person" %in% index2$label)
  expect_true("name" %in% index1$property_keys)
  expect_true("name" %in% index2$property_keys)
})