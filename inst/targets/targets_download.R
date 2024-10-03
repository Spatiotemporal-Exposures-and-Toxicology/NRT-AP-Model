targets_download <-
  list(
      tar_target( # Test download data with amadeus
          download_narr,
          wrap_download_narr( year, directory_to_save = "/input/narr_monolevel"),
          pattern = map(year), 
          iteration = "vector"),

      tar_target( #aqs download
        aqs_download, 
        wrap_download_aqs( year, directory_to_save = "/input/aqs"),
        pattern = map(year), 
        iteration = "vector")
  
  )# End list


