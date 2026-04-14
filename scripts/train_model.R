# ----------------------------------------------------
# Script: train_model.R
# Description: Multi-Class Model Training
# ----------------------------------------------------

source("scripts/utils.R", local = TRUE)

cat("=== Starting Model Training ===\n")

df_train <- readRDS("data/processed/train_features.rds")
df_train$Failure_Type <- as.factor(df_train$Failure_Type)

ctrl <- trainControl(
  method = "none",
  classProbs = TRUE
)

# 1. Decision Tree (Baseline for IoT)
cat("[INFO] Training Multi-Class Decision Tree...\n")
set.seed(42)
dt_model <- train(
  Failure_Type ~ ., 
  data = df_train, 
  method = "rpart", 
  preProcess = c("center", "scale"),
  trControl = ctrl
)
saveRDS(dt_model, "models/dt_model.rds")
cat("[OK] Decision Tree saved.\n")

# 2. Random Forest (Robust Ensembling)
cat("[INFO] Training Random Forest... (May take a few minutes)\n")
set.seed(42)
rf_grid <- expand.grid(.mtry = 3)
rf_model <- train(
  Failure_Type ~ ., 
  data = df_train, 
  method = "rf", 
  ntree = 50,
  preProcess = c("center", "scale"),
  tuneGrid = rf_grid,
  trControl = ctrl
)
saveRDS(rf_model, "models/rf_model.rds")
cat("[OK] Random Forest saved.\n")


# 3. Gradient Boosting Machine (SOTA for Tabular multi-class)
cat("[INFO] Training Gradient Boosting Machine...\n")
set.seed(42)
gbm_grid <- expand.grid(
  interaction.depth = 5,
  n.trees = 50,
  shrinkage = 0.1,
  n.minobsinnode = 10
)
gbm_model <- train(
  Failure_Type ~ ., 
  data = df_train, 
  method = "gbm", 
  preProcess = c("center", "scale"),
  tuneGrid = gbm_grid,
  trControl = ctrl,
  verbose = FALSE
)
saveRDS(gbm_model, "models/gbm_model.rds")
cat("[OK] Gradient Boosting saved.\n")

cat("=== Model Training Completed successfully ===\n\n")
