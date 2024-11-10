#' Preprocessing function for centering, scaling, and log transformation
center_scale_fun <- function(.data_clean, 
                             log_transform = FALSE,
                             center = TRUE,
                             scale = TRUE) {
  
  suppressPackageStartupMessages({
    library(tidyverse)
  })
  
  data_pre_processed <- .data_clean
  
  # Perform log transformation (adding 1 to handle zeros, negative values shifted)
  if (log_transform) {
    data_pre_processed <- data_pre_processed |>
      mutate(across(where(is.numeric), ~if_else(. >= 0, log(. + 1), log(abs(.) + 1))))
  } 
  
  # Perform centering and scaling
  if (center & scale) {
    data_pre_processed <- data_pre_processed |>
      mutate(across(where(is.numeric), ~(. - mean(., na.rm = TRUE)) / sd(., na.rm = TRUE)))
  } else {
    # Perform centering only
    if (center) {
      data_pre_processed <- data_pre_processed |>
        mutate(across(where(is.numeric), ~(. - mean(., na.rm = TRUE))))
    }
    # Perform scaling only
    if (scale) {
      data_pre_processed <- data_pre_processed |>
        mutate(across(where(is.numeric), ~(. / sd(., na.rm = TRUE))))
    }
  }
  
  # Mean imputation for missing values (after transformation)
  data_pre_processed <- data_pre_processed |>
    mutate(across(where(is.numeric), ~if_else(is.na(.), mean(., na.rm = TRUE), .)))
  
  return(data_pre_processed)
}

