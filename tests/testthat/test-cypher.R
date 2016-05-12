library(RNeo4j)
context("Cypher")

skip_on_cran()

options(digits=20)

neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
importSample(neo4j, "movies", input=F)


test_that("cypher works", {
  options(stringsAsFactors=F)
  expected = data.frame(name = c("Aaron Sorkin", "Al Pacino", "Andy Wachowski", "Angela Scope", "Annabella Sciorra"))
  actual = cypher(neo4j, "MATCH (p:Person) RETURN p.name AS name ORDER BY p.name LIMIT 5;")
  expect_identical(actual, expected)
})

test_that("cypher retrieves arrays correctly", {
  query = "
  MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
  RETURN m.title, COLLECT(p.name)
  LIMIT 5;
  "
  
  data = cypher(neo4j, query)
  classes = sapply(data, class)
  expect_true("list" %in% classes)
})

test_that("cypher works with parameters", {
  query = "MATCH (p:Person) WHERE p.name = {actor} RETURN p.name"
  data = cypher(neo4j, query, actor="Tom Hanks")
  expect_equal(data[1, 1], "Tom Hanks")
})

test_that("cypher works with array parameters", {
  query = "MATCH (p:Person) WHERE p.name IN {names} RETURN p.name;"
  data = cypher(neo4j, query, names=c("Tom Hanks", "Tom Cruise"))
  expect_equal(nrow(data), 2)
})

test_that("cypher doesn't round numeric parameters", {
  NUMBER = 123456789
  query = "RETURN {number}"
  data = cypher(neo4j, query, number=NUMBER)
  expect_equal(data[1, 1], NUMBER)
})

test_that("cypher handles nulls correctly", {
  expected = data.frame(
    n.thing = c(
      rep(NA, 10)
    )
  )
  actual = cypher(neo4j, "MATCH (n) RETURN n.thing LIMIT 10")
  expect_identical(actual, expected)
})

test_that("cypher won't return graph results - paths", {
  q = "MATCH p = ()-[]-() RETURN p, LENGTH(p) LIMIT 2"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
  q = "MATCH p = ()-[]-() RETURN LENGTH(p), p"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
})

test_that("cypher won't return graph results - nodes", {
  q = "MATCH (n) WITH n LIMIT 2 RETURN n.name, n"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
  q = "MATCH (n) WITH n LIMIT 2 RETURN n, n.name"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
})

test_that("cypher won't return graph results - relationships", {
  q = "MATCH ()-[r]-() WITH r LIMIT 2 RETURN r.name, r"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
  q = "MATCH ()-[r]-() WITH r LIMIT 2 RETURN r, r.name"
  expect_error(cypher(neo4j, q), "You must query for tabular results when using this function.")
})

test_that("cypher throws error on invalid query", {
  expect_error(cypher(neo4j, "MATCH (n) RETURN m"))
})

test_that("it works with multiple parameters", {
  query = "
  MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
  WHERE p.name = {actor} AND m.title = {title}
  RETURN p.name, m.title;
  "
  
  data = cypher(neo4j, query, actor="Tom Hanks", title="Apollo 13")
  expect_equal(data[1, 1], "Tom Hanks")
})

test_that("it works with a list of parameters", {
  query = "
  MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
  WHERE p.name = {actor} AND m.title = {title}
  RETURN p.name, m.title;
  "
  
  data = cypher(neo4j, query, list(actor="Tom Hanks", title="Apollo 13"))
  expect_equal(data[1, 1], "Tom Hanks")
})