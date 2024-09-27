targets_aqs <-
  list(
    targets::tar_target(
      sf_download_aqs_sites,
      command  = amadeus::download_aqs(
        parameter_code = "88101", #PM2.5
        
        ),
        date = arglist_common$char_period,
        mode = "location",
        return_format = "sf"
      ),
      description = "AQS sites"
    )
    ,
    targets::tar_target(
      dt_feat_proc_aqs_sites_time,
      read_locs(
        path = list.files(
          path = file.path(arglist_common$char_input_dir, "aqs", "data_files"),
          pattern = "daily_88101_[0-9]{4}.csv",
          full.names = TRUE
        ),
        date = arglist_common$char_period,
        mode = "available-data",
        data_field = c("Arithmetic.Mean", "Event.Type"),
        return_format = "data.table"
      ),
      description = "AQS sites with time"
    )
  )
