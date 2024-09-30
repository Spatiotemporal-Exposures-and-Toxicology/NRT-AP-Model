# 1) tar_target for every covariate - including dataset + product/collection
# 2) branch by year
target_download <-
  list(
     tar_target(download_aqs, 
     command = amadeus::download_aqs(
       parameter_code = "88101", #PM2.5
       resolution_temporal  = "daily",
       year = year$aqs,
       download = TRUE
     ), 
     pattern = map(year)),

     tar_target(download_MOD09GA,
      command = amadeus::download_modis(
        product = "MOD09GA",
        collection = "6",
        date = arglist_common$char_period,
        download = TRUE
      ) 
      pattern = map(year))

  )
