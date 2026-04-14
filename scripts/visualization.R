# ----------------------------------------------------
# Script: visualization.R
# Description: Generates EDA and Evaluation Plots
# ----------------------------------------------------

source("scripts/utils.R", local = TRUE)

cat("=== Starting Visualization Module ===\n")

dir.create("outputs/plots/", recursive = TRUE, showWarnings = FALSE)

results_list <- readRDS("outputs/reports/eval_results.rds")
models <- names(results_list)
acc <- sapply(results_list, function(x) x$Accuracy)

perf_df <- data.frame(
  Model = models,
  Accuracy = acc
)

cat("[INFO] Generating Accuracy Bar Chart...\n")
png("outputs/plots/model_comparison.png", width = 800, height = 600)
bp <- barplot(acc, names.arg = models, col = c("coral", "steelblue", "forestgreen"), 
              main = "Multi-Class Accuracy Comparison", ylab = "Overall Accuracy", ylim = c(0, 1))
text(bp, acc - 0.05, labels = paste0(round(acc*100, 1), "%"), col="white", font=2)
dev.off()

cat("[INFO] Generating Torque vs Rotational Speed EDA...\n")
raw_df <- read.csv("data/raw/predictive_maintenance.csv")
raw_df$Failure.Type <- make.names(raw_df$Failure.Type)

png("outputs/plots/torque_vs_speed.png", width = 800, height = 600)
colors <- as.numeric(as.factor(raw_df$Failure.Type))
palette(c("black", "red", "blue", "green", "purple", "orange"))
plot(raw_df$Rotational.speed..rpm., raw_df$Torque..Nm., 
     col = colors, pch = 16, cex = 0.6,
     main = "Machine Failure Profile: Torque vs Speed", 
     xlab = "Rotational Speed (RPM)", ylab = "Torque (Nm)")
legend("topright", legend = levels(as.factor(raw_df$Failure.Type)), col = 1:6, pch = 16, cex = 0.8)
dev.off()

cat("[INFO] Generating Feature Importance Plot (GBM)...\n")
suppressWarnings({
  gbm_model <- readRDS("models/gbm_model.rds")
  importance <- as.data.frame(varImp(gbm_model)$importance)
  importance$Feature <- rownames(importance)
  
  if("Overall" %in% names(importance)) {
    imp_df <- importance
  } else {
    overall_imp <- rowMeans(importance[, !names(importance) %in% "Feature"])
    imp_df <- data.frame(Feature=importance$Feature, Overall=overall_imp)
  }
  
  imp_df <- imp_df[order(imp_df$Overall, decreasing = FALSE), ]
  
  png("outputs/plots/feature_importance.png", width = 800, height = 600)
  par(mar=c(5, 8, 4, 2))
  barplot(imp_df$Overall, names.arg = imp_df$Feature, horiz=TRUE, las=1, 
          col="darkred", main="Predictive Maintenance Feature Importance", 
          xlab="Average Importance")
  dev.off()
})

cat("=== Visualization Completed successfully ===\n\n")
