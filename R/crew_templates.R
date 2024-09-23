#'
#' crew and crew.cluster template for slurm
#' name: crew_template_slurm.R
#' 
# Slurm template for crew.cluster
crew_template_slurm <- function(partition = "geo", gres = NULL, cpus_per_task = 1, memory = "4G", time = "01:00:00") {
  list(
    command = "Rscript",
    args = c(
      "-e",
      "crew::crew_worker()"
    ),
    script = NULL,
    environment = NULL,
    slurm_options = list(
      partition = partition,
      gres = gres,
      cpus_per_task = cpus_per_task,
      mem = memory,
      time = time
    )
  )
}

# Local template for crew.cluster
crew_template_local <- function() {
  list(
    command = "Rscript",
    args = c(
      "-e",
      "crew::crew_worker()"
    ),
    script = NULL,
    environment = NULL
  )
}
