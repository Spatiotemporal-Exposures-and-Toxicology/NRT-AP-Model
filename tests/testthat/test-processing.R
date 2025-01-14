################################################################################
##### unit and integration tests for data processing functions
##### main files: R/processing.R, R/processing_misc.R

################################################################################
##### divisor
divisor(100)
testthat::test_that("divisor", {
  # expect no error with integer
  testthat::expect_no_error(
    divs_100 <- divisor(100)
  )
  testthat::expect_true(is.integer(divs_100))
  testthat::expect_length(divs_100, 9)

  # expect error with character
  testthat::expect_error(
    divisor("abc")
  )
})
