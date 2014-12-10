library(RNeo4j)
context("Create a Neo4j graph")

test_that("sends the correct URI to Neo4j server", {
  fake_neo4j_version = "{'neo4jVersion': 'test.version.number'}"

  dummy_request_with_uri = function(expected_uri) {
    function(url, request_type, wanted_status, postfields = NULL, httpheader = NULL) {
      expect_that(url, equals(expected_uri))
      fake_neo4j_version
    }
  }

  expect_that(
    startGraph("http://localhost:7574", http_fn = dummy_request_with_uri("http://localhost:7574")),
    is_a("graph"))

  expect_that(
    startGraph("http://localhost:7574", "mark", "mark", http_fn = dummy_request_with_uri("http://mark:mark@localhost:7574")),
    is_a("graph"))

  expect_that(
    startGraph("https://localhost:7574", "mark", "mark", http_fn = dummy_request_with_uri("https://mark:mark@localhost:7574")),
    is_a("graph"))
})

test_that("exits immediately if invalid args are passed", {
  expect_that(startGraph(123), throws_error())
  expect_that(startGraph(c("http://localhost:7474")), throws_error())
})
