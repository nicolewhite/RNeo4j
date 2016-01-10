library(RNeo4j)
context("Internals")

# skip_on_cran()

test_that("find_max_dig works with integers", {
  params = list(name="Nicole", age=24)
  expect_equal(find_max_dig(params), 2)
})

test_that("find_max_dig works with floats", {
  params = list(name="Nicole", f=2015.1114)
  expect_equal(find_max_dig(params), 8)
})

test_that("find_max_dig works with a combination of floats and integers", {
  params = list(i=5, f=5.56)
  expect_equal(find_max_dig(params), 3)
})

test_that("find_max_dig works with a combination of floats and integers, short after long", {
  params = list(i=5.56, f=5)
  expect_equal(find_max_dig(params), 3)
})