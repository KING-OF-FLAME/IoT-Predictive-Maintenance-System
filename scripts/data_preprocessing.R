# ----------------------------------------------------
# Script: data_preprocessing.R
# Description: IoT Data Cleaning and UpSampling
# ----------------------------------------------------

source("scripts/utils.R", local = TRUE)

cat("=== Starting Preprocessing for Predictive Maintenance ===\n")

# Provide an absolute or valid relative path
raw_file <- "data/raw/predictive_maintenance.csv"
if (!file.exists(raw_file)) stop("Dataset missing. Verify using utils.R first.")

df <- read.csv(raw_file, header = TRUE, stringsAsFactors = FALSE)
cat("[INFO] Raw Dimensions:", dim(df)[1], "rows,", dim(df)[2], "cols\n")

# 1. Standardize complex IoT Column Names
names(df) <- make.names(names(df))
# Usually: UDI, Product.ID, Type, Air.temperature..K., Process.temperature..K., 
# Rotational.speed..rpm., Torque..Nm., Tool.wear..min., Target, Failure.Type

# 2. Select and clean features
# Drop identifiers 'UDI', 'Product.ID' and binary leakage 'Target'
# Keep 'Failure.Type' as the multi-class target to predict
# Filter columns securely (in case of subtle name variations)
df <- df %>% select(-Target, -UDI, -Product.ID)

# Rename columns to standardized simple names
df <- df %>% rename(
  Air_Temp = Air.temperature..K.,
  Process_Temp = Process.temperature..K.,
  Rotational_Speed = Rotational.speed..rpm.,
  Torque = Torque..Nm.,
  Tool_Wear = Tool.wear..min.,
  Failure_Type = Failure.Type
)

# 3. Factorizing
df$Type <- as.factor(df$Type)

# Caret requires factors with standard characters for the predictor class
df$Failure_Type <- make.names(df$Failure_Type) 
df$Failure_Type <- as.factor(df$Failure_Type)

# 4. Train/Test Split
set.seed(42)
trainIndex <- createDataPartition(df$Failure_Type, p = .8, list = FALSE, times = 1)
df_train <- df[trainIndex, ]
df_test  <- df[-trainIndex, ]

cat("[INFO] Splitting Completed. Train:", nrow(df_train), "Test:", nrow(df_test), "\n")

# 5. Handle Extreme Industry 4.0 Class Imbalance
# 'No Failure' makes up 96.5% of the data. 
# We use UpSampling on the training set to amplify the minority Machine Failures.
cat("[INFO] Class distribution prior to balancing:\n")
print(table(df_train$Failure_Type))

# Caret's upSample amplifies all minorities to the size of the majority class
df_train_balanced <- upSample(x = df_train %>% select(-Failure_Type),
                              y = df_train$Failure_Type,
                              yname = "Failure_Type")

cat("[INFO] Class distribution AFTER up-sampling:\n")
print(table(df_train_balanced$Failure_Type))

# 6. Save data
saveRDS(df_train_balanced, "data/processed/train_processed.rds")
saveRDS(df_test, "data/processed/test_processed.rds")

cat("=== Data Preprocessing Completed successfully ===\n\n")
