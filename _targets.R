library(targets)
library(tarchetypes)
library(dplyr)
library(crew)
library(future)
library(future.batchtools)
library(beethoven)
library(amadeus)



# replacing yaml file.
tar_config_set(
  store = "_targets"
)

geo_controller <- crew_controller_local(
  name = "geo_controller",
  workers = 16L,
  launch_max = 8L,
  seconds_idle = 120
)


tar_source("inst/targets/targets_initialize.R")
tar_source("inst/targets/targets_download.R")

generate_list_download <- TRUE

arglist_download <-
  set_args_download(
    char_period = c("2018-01-01", "2022-12-31"),
    char_input_dir = "input",
    nasa_earth_data_token = Sys.getenv("NASA_EARTHDATA_TOKEN"),
    mod06_filelist = "inst/targets/mod06_links_2018_2022.csv",
    export = generate_list_download,
    path_export = "inst/targets/download_spec.qs"
  )

generate_list_calc <- TRUE

arglist_common <-
  set_args_calc(
    char_siteid = "site_id",
    char_timeid = "time",
    char_period = c("2018-01-01", "2022-12-31"),
    num_extent = c(-126, -62, 22, 52),
    char_user_email = paste0(Sys.getenv("USER"), "@nih.gov"),
    export = generate_list_calc,
    path_export = "inst/targets/calc_spec.qs",
    char_input_dir = "input"
  )


# tar_source("beethoven/inst/targets/targets_calculate.R")
# tar_source("beethoven/inst/targets/targets_baselearner.R")
# tar_source("beethoven/inst/targets/targets_metalearner.R")
# tar_source("beethoven/inst/targets/targets_predict.R")


# bypass option for download
Sys.setenv("BTV_DOWNLOAD_PASS" = "FALSE")





# # nullify download target if bypass option is set
if (Sys.getenv("BTV_DOWNLOAD_PASS") == "TRUE") {
  target_download <- NULL
}

# targets options
# For GPU support, users should be aware of setting environment
# variables and GPU versions of the packages.
# TODO: check if the controller and resources setting are required
tar_option_set(
  packages =
    c( "amadeus", "targets", "tarchetypes",
      "data.table", "sf", "terra", "exactextractr",
       "dplyr", "qs", "bonsai",
      "glmnet", "xgboost", "callr",
      "stars", "rlang"),
  controller = crew_controller_group(geo_controller),
  resources = tar_resources(
    crew = tar_resources_crew(controller = "geo_controller")
  ),  
  error = "abridge",
  memory = "transient",
  format = "qs",
  storage = "worker",
  deployment = "worker",
  garbage_collection = TRUE,
  seed = 202401L
)


list(
  target_init,
  target_download
  # target_calculate_fit,
  # target_baselearner#,
  # target_metalearner,
  # target_calculate_predict,
  # target_predict,
  # # documents and summary statistics
  # targets::tar_target(
  #   summary_urban_rural,
  #   summary_prediction(
  #     grid_filled,
  #     level = "point",
  #     contrast = "urbanrural"))
  # ,
  # targets::tar_target(
  #   summary_state,
  #   summary_prediction(
  #     grid_filled,
  #     level = "point",
  #     contrast = "state"
  #   )
  # )
)

# targets::tar_visnetwork(targets_only = TRUE)
# END OF FILE
