# tests/testthat/test_crew_*.R
# Tests for the crew package

# Basic dispatching and functioning over
# 1) Normal partition
# 2) Geo Partition
# 3) Highmem partition 


################################################################################
##### tests for crew.cluster on geo

################################################################################
test_that("Crew.cluster with default partition as geo and minimal resources", {


  # Invalidate the targets
  tar_destroy(ask = FALSE)  

  skip_on_cran()
  #skip_if_not_installed("crew.cluster")
  # Set up a crew.cluster controller for local testing with 1 worker

  controller_local <- crew_controller_local(
  name = "my_local_controller",
  workers = 2,
  seconds_idle = 10)

controller_geo <- crew_controller_slurm(
  name = "my_slurm_controller",
  workers = 3,
  seconds_idle = 15,
  script_lines = "module load R",
  slurm_log_output = "../slurm/crew_log_%A.out",
  slurm_memory_gigabytes_per_cpu = 16       
)
tar_option_set(
  controller = crew_controller_group(controller_local, controller_geo),
  resources = tar_resources(
    crew = tar_resources_crew(controller = "my_local_controller")
  )
)


  # controller <- crew_controller_slurm(
  #   name = "geo",
  #   workers = 5L,
  #   slurm_log_error = "../slurm/crew_log_%A.err",
  #   script_lines = c(
  #   paste0("module load R/", getRversion()),
  #   "#SBATCH --job-name=crew_job",
  #   "#SBATCH --mail-user=kyle.messier@nih.gov",
  #   "#SBATCH --mail-type=END,FAIL"
  # ),
  #   slurm_partition = "geo",
  #   slurm_memory_gigabytes_per_cpu = 4,       
  # )

    # tar_option_set(controller = crew::crew_controller_group(controller),
    #   resources =  tar_resources(
    #      crew = tar_resources_crew(
    #      controller = "geo"
    # )))

    # packages = c("targets", "crew", "crew.cluster"))


  # Define a simple pipeline
  tar_script({
    library(targets)
    library(crew)
    library(crew.cluster)
    list(
      tar_target(a, 1:5, 
          memory = "transient"),
      tar_target(b, a^2,
          memory = "transient",
          pattern = map(a), 
          resources = tar_resources(
          crew = tar_resources_crew(controller = "my_slurm_controller")
    ))
    )
  }, ask = FALSE)


   


  # Run the pipeline with tar_make() using crew.cluster
  tar_make()

  # Assertions
  expect_equal(as.numeric(tar_read(b)), c(1, 4, 9, 16, 25))


})

############

test_that("crew SLURM with many tasks and many workers on default partition: normal", {
  skip_on_cran()
  skip_if_not_installed("crew.cluster")

  # Invalidate the targets
  tar_destroy(ask = FALSE)  

  tar_script({
    library(targets)
    controller <- crew.cluster::crew_controller_slurm(
      workers = 25,
      tasks_max = 100,
      script_lines = paste0("module load R/", getRversion()),
      slurm_memory_gigabytes_per_cpu = 4,       
    )
    tar_option_set(controller = crew::crew_controller_group(controller))
    list(
      tar_target(x, seq_len(30), memory = "transient"),
      tar_target(y, Sys.sleep(3), pattern = map(x), memory = "transient")
    )
  }, ask = FALSE)
  tar_make()
  expect_equal(tar_outdated(reporter = "forecast"), character(0))
})
