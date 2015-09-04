library(testthat)
library(RNeo4j)

Sys.setenv(R_TESTS = "")
Sys.setenv(NOT_CRAN = "true")

skip_on_cran()

test_check("RNeo4j")
