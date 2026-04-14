# ----------------------------------------------------
# Script: feature_engineering.R
# Description: Generates advanced Mechanical Features
# ----------------------------------------------------

source("scripts/utils.R", local = TRUE)

cat("=== Starting Feature Engineering ===\n")

df_train <- readRDS("data/processed/train_processed.rds")
df_test  <- readRDS("data/processed/test_processed.rds")

engineer_features <- function(data) {
  
  # A. Mechanical Power: Conceptually Power corresponds to Speed * Torque
  # Note: Standard physics equation Power (Watts) = Torque (Nm) * Angular velocity (rad/s)
  # Here we use a proportional placeholder: Rotational_Speed * Torque
  data$Power <- data$Rotational_Speed * data$Torque
  
  # B. Temperature Difference: Key indicator for 'Heat Dissipation Failures'
  data$Temp_Difference <- data$Process_Temp - data$Air_Temp
  
  # C. Strain / Wear Ratio: Interaction between Torque and accumulated Tool Wear
  data$Tool_Strain <- data$Tool_Wear * data$Torque
  
  return(data)
}

df_train <- engineer_features(df_train)
df_test  <- engineer_features(df_test)

cat("[INFO] New Mechanical Features Engineered: Power, Temp_Difference, Tool_Strain\n")

cat("[INFO] Numerical sensors preserved in raw scale for Caret auto-processing.\n")

# Save features
saveRDS(df_train, "data/processed/train_features.rds")
saveRDS(df_test, "data/processed/test_features.rds")

cat("=== Feature Engineering Completed successfully ===\n\n")
