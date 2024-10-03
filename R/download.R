

wrap_download_narr <- function(year, directory_to_save) {

    amadeus::download_narr(
        variables = c("weasd", "omega"),
        year = c(year, year),
        directory_to_save = directory_to_save,
        acknowledgement = TRUE,
        download = TRUE, 
        remove_command = TRUE)

      # Create and return a hash of the downloaded files
      h <- rlang::hash_file("input/narr_monolevel")  
      return(h)        


}


wrap_download_aqs <- function(year, directory_to_save){
    
    amadeus::download_aqs(
        parameter_code = 88101,
        resolution_temporal = "daily",
        year = c(year, year),
        url_aqs_download = "https://aqs.epa.gov/aqsweb/airdata/",
        directory_to_save = directory_to_save,
        acknowledgement = TRUE,
        download = TRUE,
        remove_command = TRUE,
        unzip = TRUE,
        remove_zip = TRUE)

      # Create and return a hash of the downloaded files
      h <- rlang::hash_file("input/aqs/data_files")  
      return(h)

}

