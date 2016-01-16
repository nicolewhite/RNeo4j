library(RNeo4j)
context("Internals")

# skip_on_cran()

test_that("longest_digit works with integers", {
  params = list(name="Nicole", age=24)
  expect_equal(longest_digit(params), 2)
})

test_that("longest_digit works with floats", {
  params = list(name="Nicole", f=2015.1114)
  expect_equal(longest_digit(params), 8)
})

test_that("longest_digit works with a combination of floats and integers", {
  params = list(i=5, f=5.56)
  expect_equal(longest_digit(params), 3)
})

test_that("longest_digit works with a combination of floats and integers, short after long", {
  params = list(i=5.56, f=5)
  expect_equal(longest_digit(params), 3)
})