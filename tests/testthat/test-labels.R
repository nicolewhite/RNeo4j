library(RNeo4j)
context("Labels")

skip_on_cran()

neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
clear(neo4j, input=F)

mugshots = createNode(neo4j, "Bar", name="Mugshots")

test_that("getLabel works", {
  lab = getLabel(mugshots)
  expect_equal(lab, "Bar")
})

test_that("addLabel works", {
  addLabel(mugshots, "Restaurant")
  lab = getLabel(mugshots)
  
  expect_true("Bar" %in% lab)
  expect_true("Restaurant" %in% lab)
})

test_that("dropLabel works with given label", {
  dropLabel(mugshots, "Restaurant")
  lab = getLabel(mugshots)
  expect_equal(lab, "Bar")
})

test_that("dropLabel works with all=TRUE", {
  dropLabel(mugshots, all=TRUE)
  lab = getLabel(mugshots)
  expect_null(lab)
})