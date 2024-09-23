# tests/testthat/test_crew_*.R
# Tests for the crew package


################################################################################
##### tests for crew.cluster on geo

################################################################################
test_that("Crew.cluster with default partition as geo and minimal resources", {
  library(targets)
  library(crew)
  library(crew.cluster)

  # Invalidate the targets
  tar_destroy(ask = FALSE)  
  
  # Set up a crew.cluster controller for local testing with 1 worker
  controller <- crew_controller_slurm(
    name = "test_geo",
    workers = 1L,
    slurm_partition = "geo",
    script_lines = paste0("module load R/", getRversion()),
    verbose = TRUE  # Enable verbose mode to print job submissions

  )

  tar_option_set(controller = controller,
    resources =  tar_resources(
    crew = tar_resources_crew(
      controller = "test_geo"
    )))


  # Define a simple pipeline
  tar_script({
    list(
      tar_target(x, 1 + 1, 
          resources = tar_resources(
          crew = tar_resources_crew(controller = "test_geo")
    ),
          deployment = "worker"),
      tar_target(y, x * 2,
          resources = tar_resources(
          crew = tar_resources_crew(controller = "test_geo")
    ), 
          deployment = "worker")
    )
  }, ask = FALSE)



   

  # Start the controller 
  controller$start()



  # Run the pipeline with tar_make() using crew.cluster
  tar_make()


  # Assertions
  expect_equal(tar_read(y), 4)

  # Clean up
  controller$terminate()
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
