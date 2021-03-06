library(ranger)
library(survival)
context("ranger_maxstat")

test_that("maxstat splitting works for survival", {
  rf <- ranger(Surv(time, status) ~ ., veteran, splitrule = "maxstat")
  expect_is(rf, "ranger")
  expect_lt(rf$prediction.error, 0.4)
})

test_that("maxstat splitting works for regression", {
  rf <- ranger(Sepal.Length ~ ., iris, splitrule = "maxstat")
  expect_is(rf, "ranger")
  expect_gt(rf$r.squared, 0.5)
})

test_that("maxstat splitting, alpha or minprop out of range throws error", {
  expect_error(ranger(Surv(time, status) ~ ., veteran, splitrule = "maxstat", alpha = -1))
  expect_error(ranger(Surv(time, status) ~ ., veteran, splitrule = "maxstat", alpha = 2))
  expect_error(ranger(Surv(time, status) ~ ., veteran, splitrule = "maxstat", minprop = -1))
  expect_error(ranger(Surv(time, status) ~ ., veteran, splitrule = "maxstat", minprop = 1))
})

test_that("maxstat splitting not working for classification", {
  expect_error(ranger(Species ~ ., iris, splitrule = "maxstat"))
})

test_that("maxstat impurity importance is positive", {
  rf <- ranger(Surv(time, status) ~ ., veteran, num.trees = 5, 
               splitrule = "maxstat", importance = "impurity")
  expect_gt(mean(rf$variable.importance), 0)
  
  rf <- ranger(Sepal.Length ~ ., iris, num.trees = 5, 
               splitrule = "maxstat", importance = "impurity")
  expect_gt(mean(rf$variable.importance), 0)
})

test_that("maxstat corrected impurity importance is positive (on average)", {
  rf <- ranger(Surv(time, status) ~ ., veteran, num.trees = 50, 
               splitrule = "maxstat", importance = "impurity_corrected")
  expect_gt(mean(rf$variable.importance), 0)
  
  rf <- ranger(Sepal.Length ~ ., iris, num.trees = 5, 
               splitrule = "maxstat", importance = "impurity_corrected")
  expect_gt(mean(rf$variable.importance), 0)
})
