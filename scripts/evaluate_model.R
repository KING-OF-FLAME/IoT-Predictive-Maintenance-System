# ----------------------------------------------------
# Script: evaluate_model.R
# Description: Evaluates Multi-Class metrics
# ----------------------------------------------------

source("scripts/utils.R", local = TRUE)

cat("=== Starting Model Evaluation ===\n")

df_test <- readRDS("data/processed/test_features.rds")

dt_model  <- readRDS("models/dt_model.rds")
rf_model  <- readRDS("models/rf_model.rds")
gbm_model <- readRDS("models/gbm_model.rds")

evaluate_performance <- function(model, test_data, model_name) {
  preds_class <- predict(model, newdata = test_data)
  test_actual <- factor(test_data$Failure_Type, levels = levels(preds_class))
  
  cm <- confusionMatrix(preds_class, test_actual)
  Accuracy <- cm$overall["Accuracy"]
  
  cat(sprintf("\n--- %s ---\n", model_name))
  cat(sprintf("Overall Accuracy:  %.4f\n\n", Accuracy))
  print(cm$byClass[, c("Sensitivity", "Specificity", "F1")])
  
  result <- list(
    ModelName = model_name,
    Accuracy = Accuracy,
    ConfusionMatrix = cm
  )
  return(result)
}

cat("\n[INFO] Evaluating Decision Tree...\n")
dt_eval <- evaluate_performance(dt_model, df_test, "Decision Tree")

cat("\n[INFO] Evaluating Random Forest...\n")
rf_eval <- evaluate_performance(rf_model, df_test, "Random Forest")

cat("\n[INFO] Evaluating Gradient Boosting...\n")
gbm_eval <- evaluate_performance(gbm_model, df_test, "Gradient Boosting")

results_list <- list(
  DecisionTree = dt_eval,
  RandomForest = rf_eval,
  GradientBoosting = gbm_eval
)

saveRDS(results_list, "outputs/reports/eval_results.rds")

cat("\n=== Model Evaluation Completed successfully ===\n\n")
