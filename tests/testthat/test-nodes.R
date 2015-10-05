library(RNeo4j)
context("Nodes")

skip_on_cran()

options(digits=20)

neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
clear(neo4j, input=F)

test_that("createNode works without any properties", {
  clear(neo4j, input=F)
  n = createNode(neo4j, "Person")
  expect_equal(length(n), 0)
})

test_that("createNode works without any properties or labels", {
  clear(neo4j, input=F)
  createNode(neo4j)
})

test_that("createNode works with properties set to NA", {
  clear(neo4j, input=F)
  n = createNode(neo4j, "Person", name="Nicole", age=NA)
  expect_equal(n$name, "Nicole")
  expect_null(n$age)
})

test_that("createNode works with properties set to NULL", {
  clear(neo4j, input=F)
  n = createNode(neo4j, "Person", name="Nicole", age=NULL)
  expect_equal(n$name, "Nicole")
  expect_null(n$age)
})

test_that("createNode doesn't round numeric parameters", {
  clear(neo4j, input=F)
  AGE = 123456789
  n = createNode(neo4j, "Person", age=AGE)
  n = getSingleNode(neo4j, "MATCH n WHERE n.age = {age} RETURN n", age=AGE)
  expect_equal(n$age, AGE)
})

test_that("getNodes works", {
  clear(neo4j, input=F)
  
  mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
  nastys = createNode(neo4j, "Bar", name="Nasty's")
  
  nodes = getNodes(neo4j, "MATCH n RETURN n")
  
  names = sapply(nodes, '[[', 'name')
  expect_true("Mugshots" %in% names)
  expect_true("Nasty's" %in% names)
})

test_that("getSingleNode works", {
  clear(neo4j, input=F)
  mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
  node = getSingleNode(neo4j, "MATCH (b:Bar {name:'Mugshots'}) RETURN b")
  expect_equal(node$location, "México")
})

test_that("getUniqueNode works", {
  clear(neo4j, input=F)
  mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
  
  addConstraint(neo4j, "Bar", "name")
  node = getUniqueNode(neo4j, "Bar", name="Mugshots")
  expect_identical(class(node), c("entity", "node"))
})

test_that("getOrCreateNode works", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Bar", "name")
  
  mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
  
  node = getOrCreateNode(neo4j, "Bar", name="Mugshots")
  expect_identical(class(node), c("entity", "node"))
})

test_that("getOrCreateNode works with last of parameters", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Bar", "name")
  
  mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
  
  node = getOrCreateNode(neo4j, "Bar", list(name="Mugshots", other="Other"))
  expect_identical(class(node), c("entity", "node"))
  expect_null(node$other)
})

test_that("getOrCreateNode works with NA properties when the node already exists", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Bar", "name")
  
  mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
  
  n = getOrCreateNode(neo4j, "Bar", name="Mugshots", location=NA)
  
  expect_equal(n$name, "Mugshots")
  expect_equal(n$location, "México")
})

test_that("getOrCreateNode works with NULL properties when the node already exists", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "Bar", "name")
  
  mugshots = createNode(neo4j, "Bar", name="Mugshots", location="México")
  
  n = getOrCreateNode(neo4j, "Bar", name="Mugshots", location=NULL)
  
  expect_equal(n$name, "Mugshots")
  expect_equal(n$location, "México")
})

test_that("getOrCreateNode works with NA properties when the node doesn't already exist", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "User", "user_id_hash")
  
  n = getOrCreateNode(neo4j, "User", user_id_hash="john", age=NA)
  
  expect_equal(n$user_id_hash, "john")
  expect_null(n$age)
})

test_that("getOrCreateNode works with NULL properties when the node doesn't already exist", {
  clear(neo4j, input=F)
  addConstraint(neo4j, "User", "user_id_hash")
  
  n = getOrCreateNode(neo4j, "User", user_id_hash="john", age=NULL)
  
  expect_equal(n$user_id_hash, "john")
  expect_null(n$age)
})

test_that("getLabeledNodes works", {
  clear(neo4j, input=F)
  
  node1 = createNode(neo4j, "Something")
  node2 = createNode(neo4j, "Something", prop=1)
  
  somethings = getLabeledNodes(neo4j, "Something")
  x = class(somethings[[1]])
  
  expect_equal(length(somethings), 2)
  expect_true("node" %in% x)
  
  somethings1 = getLabeledNodes(neo4j, "Something", prop=1)
  x = class(somethings1[[1]])
  
  expect_equal(length(somethings1), 1)
  expect_true("node" %in% x)
})

test_that("delete works", {
  clear(neo4j, input=F)
  
  n = createNode(neo4j, "Thing", name="Nicole")
  delete(n)
  
  n = getSingleNode(neo4j, "MATCH (n:Thing) WHERE n.name = 'Nicole' RETURN n")
  expect_null(n)
})

test_that("createNode can set properties passed as a list", {
  clear(neo4j, input=F)
  
  n = createNode(neo4j, "Thing", list(name="Nicole", age=24))
  
  expect_equal(n$name, "Nicole")
  expect_equal(n$age, 24)
})