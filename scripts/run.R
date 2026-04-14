# ----------------------------------------------------
# Script: run.R
# Description: Master Execution Script for Maintenance
# ----------------------------------------------------

cat("========================================================\n")
cat("      PREDICTIVE MAINTENANCE CLASSIFICATION SYSTEM      \n")
cat("                    (Industry 4.0)                      \n")
cat("========================================================\n\n")

start_time <- Sys.time()

# 1. Setup Environment
source("scripts/utils.R")

cat(">> Step 1: Installing and Loading Required Packages...\n")
install_and_load_packages(required_packages)

cat("\n>> Step 2: Verifying IoT Maintenance Dataset...\n")
verify_dataset()

# 2. Run Scripts Sequentially
cat("\n>> Step 3: Running Preprocessing & Multi-Class Smote...\n")
source("scripts/data_preprocessing.R", local = TRUE)

cat("\n>> Step 4: Engineering Physics Features (Power, Strain)...\n")
source("scripts/feature_engineering.R", local = TRUE)

cat("\n>> Step 5: Training Algorithms (RF & XGBoost)...\n")
source("scripts/train_model.R", local = TRUE)

cat("\n>> Step 6: Evaluating Models...\n")
source("scripts/evaluate_model.R", local = TRUE)

cat("\n>> Step 7: Generating Visualizations...\n")
source("scripts/visualization.R", local = TRUE)

end_time <- Sys.time()
execution_time <- round(difftime(end_time, start_time, units = "mins"), 2)

cat("==================================================\n")
cat("          PIPELINE EXECUTED SUCCESSFULLY          \n")
cat(sprintf("          Total Execution Time: %s mins         \n", execution_time))
cat("==================================================\n")
cat("Plots -> 'outputs/plots/'\nModels -> 'models/'\n")
