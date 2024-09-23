# tests/testthat/test_crew_*.R
# Tests for the crew package


################################################################################
##### tests for crew.cluster on geo

################################################################################
test_that("Crew.cluster with default partition as geo and minimal resources", {


  # Invalidate the targets
  tar_destroy(ask = FALSE)  

  skip_on_cran()
  skip_if_not_installed("crew.cluster")
  # Set up a crew.cluster controller for local testing with 1 worker
  controller <- crew_controller_slurm(
    name = "test_geo",
    workers = 5L,
    slurm_log_output = "crew_log_%A.out",
    slurm_log_error = "crew_log_%A.err",
    script_lines = paste0("module load R/", getRversion()),
    slurm_cpus_per_task = 2,
    slurm_partition = "geo"       
  )

  tar_option_set(controller = controller,
    resources =  tar_resources(
    crew = tar_resources_crew(
      controller = "test_geo"
    )))
    # packages = c("targets", "crew", "crew.cluster"))


  # Define a simple pipeline
  tar_script({
    library(targets)
    library(crew)
    library(crew.cluster)
    list(
      tar_target(a, 1:5, 
          resources = tar_resources(
          crew = tar_resources_crew(controller = "test_geo")
    )),
      tar_target(b, a^2,
          resources = tar_resources(
          crew = tar_resources_crew(controller = "test_geo")),
          pattern = map(a))
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
      script_lines = paste0("module load R/", getRversion())
    )
    tar_option_set(controller = crew::crew_controller_group(controller))
    list(
      tar_target(x, seq_len(1000)),
      tar_target(y, Sys.sleep(0.1), pattern = map(x))
    )
  }, ask = FALSE)
  tar_make()
  expect_equal(tar_outdated(reporter = "forecast"), character(0))
})


# ################################################################################
# test_that("Crew.cluster with default partition as highmem and minimal resources", {
#   library(targets)
#   library(crew.cluster)

#   # Define a simple pipeline
#   tar_script({
#     list(
#       tar_target(x, 1 + 1),
#       tar_target(y, x * 3)
#     )
#   }, ask = FALSE)

#   # Set up a crew.cluster controller for local testing with 1 worker
#   controller <- crew_cluster(
#     workers = 1,
#     template = crew_template_local(partition = "highmem") # other inputs as default
#   )
#   controller$start()

#   # Run the pipeline with tar_make() using crew.cluster
#   tar_make(controller = controller)

#   # Assertions
#   expect_equal(tar_read(y), 6)

#   # Clean up
#   controller$terminate()
# })


# # tests/testthat/test_crew_cluster_geo_cpu.R

# test_that("Crew.cluster on 'geo' partition with multiple workers for CPU tasks", {
#   library(targets)
#   library(crew.cluster)

#   # Define a dynamic branching pipeline
#   tar_script({
#     list(
#       tar_target(
#         data_chunks,
#         seq_len(100),
#         iteration = "list"
#       ),
#       tar_target(
#         results,
#         heavy_cpu_task(data_chunks),
#         pattern = map(data_chunks)
#       )
#     )
#   }, ask = FALSE)

#   # Set up a Slurm crew.cluster controller for CPU tasks on 'geo' partition
#   controller <- crew_cluster(
#     workers = 10,
#     template = crew_template_slurm(
#       partition = "geo"
#     )
#   )
#   controller$start()

#   # Run the pipeline with tar_make() using crew.cluster
#   tar_make(controller = controller)

#   # Assertions
#   expect_equal(length(tar_read(results)), 100)

#   # Clean up
#   controller$terminate()
# })



# # tests/testthat/test_crew_cluster_geo_gpu.R

# test_that("Crew.cluster on 'geo' partition for GPU tasks", {
#   library(targets)
#   library(crew.cluster)

#   # Define a pipeline requiring GPU resources
#   tar_script({
#     list(
#       tar_target(
#         gpu_tasks,
#         seq_len(5),
#         iteration = "list"
#       ),
#       tar_target(
#         gpu_results,
#         heavy_gpu_task(gpu_tasks),
#         pattern = map(gpu_tasks)
#       )
#     )
#   }, ask = FALSE)

#   # Set up a Slurm crew.cluster controller with GPU resources
#   controller <- crew_cluster(
#     workers = 5,
#     template = crew_template_slurm(
#       partition = "geo",
#       gres = "gpu:1"  # Allocates 1 GPU per worker
#     )
#   )
#   controller$start()

#   # Run the pipeline with tar_make() using crew.cluster
#   tar_make(controller = controller)

#   # Assertions
#   expect_equal(length(tar_read(gpu_results)), 5)

#   # Clean up
#   controller$terminate()
# })
