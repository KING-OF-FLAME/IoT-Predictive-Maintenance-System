# ----------------------------------------------------
# Script: utils.R
# Description: Helper functions & Data fetch validation
# ----------------------------------------------------

required_packages <- c(
  "dplyr", "caret", "xgboost", "randomForest", 
  "ggplot2", "corrplot", "readr", "tidyr", "e1071", "gbm"
)

install_and_load_packages <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat(paste("Installing necessary package:", pkg, "\n"))
      install.packages(pkg, dependencies = TRUE, repos = "http://cran.us.r-project.org")
      library(pkg, character.only = TRUE)
    }
  }
}

verify_dataset <- function() {
  raw_dir <- "data/raw"
  file_path <- file.path(raw_dir, "predictive_maintenance.csv")
  
  if (!dir.exists(raw_dir)) {
    dir.create(raw_dir, recursive = TRUE)
  }
  
  if (file.exists(file_path)) {
    cat("[SUCCESS] Found 'predictive_maintenance.csv' securely placed in 'data/raw/'.\n")
  } else {
    cat("========================================================================\n")
    cat("[CRITICAL ERROR] The dataset is missing!\n")
    cat("1. Please visit: https://www.kaggle.com/datasets/shivamb/machine-predictive-maintenance-classification\n")
    cat("2. Click Download.\n")
    cat("3. Extract and rename it to exactly 'predictive_maintenance.csv'\n")
    cat("4. Place it in: ", raw_dir, "\n")
    cat("========================================================================\n")
    stop("Execution halted: Missing Dataset.")
  }
}
