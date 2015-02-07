library(RNeo4j)
context("Cypher")

neo4j = startGraph("http://localhost:7474/db/data/")
importSample(neo4j, "dfw", input = FALSE)

test_that("cypher handles nulls correctly", {
  expected = data.frame(
    n.thing = c(
      rep(NA, 10)
    )
  )
  actual = cypher(neo4j, "MATCH n WITH n LIMIT 10 RETURN n.thing")
  expect_equal(actual, expected)
})

test_that("cypher won't return graph results - paths", {
  q = "MATCH p = ()-[]-() RETURN p, LENGTH(p) LIMIT 2"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
  q = "MATCH p = ()-[]-() RETURN LENGTH(p), p"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
})

test_that("cypher won't return graph results - nodes", {
  q = "MATCH n WITH n LIMIT 2 RETURN n.name, n"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
  q = "MATCH n WITH n LIMIT 2 RETURN n, n.name"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
})

test_that("cypher won't return graph results - relationships", {
  q = "MATCH ()-[r]-() WITH r LIMIT 2 RETURN r.name, r"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
  q = "MATCH ()-[r]-() WITH r LIMIT 2 RETURN r, r.name"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
})

test_that("cypher throws error on invalid query", {
  expect_error(cypher(neo4j, "MATCH n RETURN m"))
})