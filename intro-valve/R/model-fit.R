# based on julia silge's screencast
# https://juliasilge.com/blog/childcare-costs/
library(pins)
library(vetiver)
library(tidyverse)
library(tidymodels)

childcare_costs <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-05-09/childcare_costs.csv')


set.seed(123)
childcare_split <- childcare_costs |>
  select(-matches("^mc_|^mfc")) |>
  select(-county_fips_code) |>
  na.omit() |>
  initial_split(strata = mcsa)

childcare_train <- training(childcare_split)
childcare_test <- testing(childcare_split)

set.seed(234)
childcare_set <- validation_split(childcare_train)
childcare_set


# Create Model Spec -------------------------------------------------------

xgb_spec <-
  boost_tree(
    trees = 500,
    min_n = tune(),
    mtry = tune(),
    stop_iter = tune(),
    learn_rate = 0.01
  ) |>
  set_engine("xgboost", validation = 0.2) |>
  set_mode("regression")

xgb_wf <- workflow(mcsa ~ ., xgb_spec)

doParallel::registerDoParallel()
set.seed(234)



# Model Fit ---------------------------------------------------------------

# cross validate
xgb_rs <- tune_grid(xgb_wf, childcare_set, grid = 15)

# train based on best model RMSE
childcare_fit <- xgb_wf |>
  finalize_workflow(select_best(xgb_rs, "rmse")) |>
  last_fit(childcare_split)

# grab the workflow and create a vetiver model
v <- extract_workflow(childcare_fit) |>
  vetiver_model("childcare-costs-xgb")


# Productionize Model -----------------------------------------------------

# create the folder for storing the model artifact
board <- board_folder("models")

# store the model
vetiver_pin_write(board, v)

# create the plumber api
vetiver_write_plumber(board, "childcare-costs-xgb")
