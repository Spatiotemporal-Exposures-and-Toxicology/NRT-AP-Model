#' Get Usage Information for a Job
#'
#' This function retrieves the usage information for a specified job.
#'
#' @param job_id A character string representing the job ID for which usage information is to be retrieved.
#' @return A data frame containing the usage information for the specified job.
#' @examples
#' \dontrun{
#'   usage_info <- get_usage("job12345")
#'   print(usage_info)
#' }
#' @export
get_resource_usage <- function(job_ids) {

  get_usage <- function(job_id) {
    cmd <- sprintf("sacct -j %s --format=JobID,MaxRSS,Elapsed -P", job_id)
    usage <- system(cmd, intern = TRUE)
    return(usage)
  }

  # Fetch resource usage for all job IDs
  resource_usages <- lapply(job_ids, get_usage)

  # Print or log resource usage (or return it)
  print(resource_usages)
  return(resource_usages)
}
