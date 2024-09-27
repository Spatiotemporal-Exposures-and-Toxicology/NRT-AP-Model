library(targets)
library(tarchetypes)
library(dplyr)
library(crew)
library(future)
library(future.batchtools)
library(beethoven)
library(amadeus)


tar_config_set(
  store = "/opt/_targets"
)

geo_controller <- crew_controller_local(
  name = "geo_controller",
  workers = 16L,
  launch_max = 8L,
  seconds_idle = 120
)






if (!nzchar(Sys.getenv("NASA_EARTHDATA_TOKEN"))){
  tar_source("/mnt/NASA_token_setup.R")
  file.exists(".netrc")
  file.exists(".urs_cookies")
  file.exists(".dodsrc")
}


arglist_download <-
  set_args_download(
    char_period = c("2018-01-01", "2022-12-31"),
    char_input_dir = "/input",
    nasa_earth_data_token = Sys.getenv("NASA_EARTHDATA_TOKEN"),
    mod06_filelist = "/pipeline/targets/mod06_links_2018_2022.csv",
    export = TRUE,
    path_export = "/pipeline/targets/download_spec.qs"
  )

# generate_list_calc <- TRUE

# arglist_common <-
#   set_args_calc(
#     char_siteid = "site_id",
#     char_timeid = "time",
#     char_period = c("2018-01-01", "2022-12-31"),
#     num_extent = c(-126, -62, 22, 52),
#     char_user_email = paste0(Sys.getenv("USER"), "@nih.gov"),
#     export = generate_list_calc,
#     path_export = "/pipeline/targets/calc_spec.qs",
#     char_input_dir = "/input"
#   )




### NOTE: It is important to source the scipts after the global variables are defined from the set_args functions
 tar_source("/pipeline/targets/my_funs.R")
 #tar_source("/pipeline/targets/targets_aqs.R")
 tar_source("/pipeline/targets/targets_download.R")




# # # nullify download target if bypass option is set
# if (Sys.getenv("BTV_DOWNLOAD_PASS") == "TRUE") {
#   target_download <- NULL
# }


tar_option_set(
  packages =
    c( "amadeus", "targets", "tarchetypes",
      "data.table", "sf", "terra", "exactextractr",
       "dplyr", "qs", "callr",  "stars", "rlang"),
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
    tar_target(name = A, command = my_fun_a(100)),
    tar_target(name = B, command = my_fun_b(A), pattern = A),
    tar_target(name = save_input, command = saveRDS(B, "/input/input.rds")),
    tar_target( # Test download data with amadeus
      download_test,
      amadeus::download_narr(
      variables = c("weasd", "omega"),
      year = c(2023, 2023),
      directory_to_save = "/input/narr_monolevel",
      acknowledgement = TRUE,
      download = TRUE, 
      remove_command = TRUE
    )
  ),
   target_download
  )


# list(
#   target_init,
#   target_download
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
# )

# targets::tar_visnetwork(targets_only = TRUE)
# END OF FILE
