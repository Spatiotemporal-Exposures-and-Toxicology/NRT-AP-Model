library(targets)
library(tarchetypes)
library(dplyr)
library(crew)
library(future)
library(beethoven)
library(amadeus)


# targets store location corresponds to _targets/ in the root of the project
tar_config_set(
  store = "/opt/_targets"
)


# crew contollers
# For now, one is set, but we can explore the use of multiple controllers
# Can also explore making the workers input for bash script or Rscript
geo_controller <- crew_controller_local(
  name = "geo_controller",
  workers = 16L,
  launch_max = 8L,
  seconds_idle = 120
)



# Setting up the NASA Earthdata token inside the container
# This needs to be tested
# if (!nzchar(Sys.getenv("NASA_EARTHDATA_TOKEN"))){
#   tar_source("/mnt/NASA_token_setup.R")
#   file.exists(".netrc")
#   file.exists(".urs_cookies")
#   file.exists(".dodsrc")
# }


# arglist_download <-
#   set_args_download(
#     char_period = c("2018-01-01", "2022-12-31"),
#     char_input_dir = "/input",
#     nasa_earth_data_token = Sys.getenv("NASA_EARTHDATA_TOKEN"),
#     mod06_filelist = "/pipeline/targets/mod06_links_2018_2022.csv",
#     export = TRUE,
#     path_export = "/pipeline/targets/download_spec.qs"
#   )






### NOTE: It is important to source the scipts after the global variables are defined from the set_args functions
tar_source("/pipeline/targets/targets_download.R")
tar_source("/mnt/R/download.R")






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



# Style below that uses sources scripts for targets by pipeline step
# Note that variables created in _targets.R are in the same local
# environment as the sourced scripts


list(
  tar_target(
    year, 
    c(2018, 2019, 2020)
  ),
  targets_download
)

# END OF FILE
