# Predictive Maintenance in Manufacturing (Industry 4.0)

## 📌 Project Title
**AI-Based IoT Predictive Maintenance Classification System**

## 💡 Problem Statement
In modern manufacturing (Industry 4.0), unexpected machine failures lead to massive downtime and revenue loss. Instead of waiting for a machine to break (Reactive Maintenance) or performing scheduled arbitrary checks (Preventive Maintenance), this project uses **Predictive Maintenance**.
By analyzing real-time IoT Telemetry data (sensors reading heat, torque, speed), our system uses Machine Learning to predict precisely **HOW** and **WHEN** a machine might fail—specifically classifying complex breakdown types like *Tool Wear Failure*, *Heat Dissipation Failure*, or *Power Failure*.

## 📊 Dataset Verification & Information
We chose a highly verified, industry-relevant 10,000 instance dataset over standard common public datasets.

**Dataset Name:** Machine Predictive Maintenance Classification
**Download Link (Kaggle):** [Click Here to Download Dataset](https://www.kaggle.com/datasets/shivamb/machine-predictive-maintenance-classification)

**Dimensions:** 10,000 rows, 10 columns.
**Features include:**
- Type (Machine Quality Label: Low, Medium, High)
- Air Temperature [K]
- Process Temperature [K]
- Rotational Speed [rpm]
- Torque [Nm]
- Tool Wear [min]
**Target Variable:** `Failure Type` (6 Unique Classes)

## 🛠 Features & Technologies Used
- **Language:** R
- **Modeling:** `caret`, `randomForest`, `xgboost`, `e1071` (SVM)
- **Engineered Logic:** Physics-based (Calculated *Strain* and *Power* via Torque equations).
- **Imbalance Handling:** Training Down-sampling for precise Multi-Class evaluation.

## 📁 Folder Structure
```text
NP/
│
├── data/
│   ├── raw/                 # YOU MUST PLACE 'predictive_maintenance.csv' HERE
│   └── processed/           # Handled by scripts
│
├── scripts/
│   ├── utils.R              # Dependency loaders
│   ├── data_preprocessing.R # Telemetry cleaning, Class balancing (Downsampling)
│   ├── feature_engineering.R# Adding Mechanical/Physics features
│   ├── train_model.R        # Multi-class RF and XGBoost
│   ├── evaluate_model.R     # Confusion Matrices and performance evaluation
│   ├── visualization.R      # Feature Importance and Scatter EDA
│   └── run.R                # Master Executable Script
│
├── outputs/plots/           # IoT analysis images exported here
├── README.md
└── requirements.txt
```

## 🚀 Correct Sequence to Run

### Step 1: Download the Data from Kaggle
1. Go to Kaggle: [Machine Predictive Maintenance](https://www.kaggle.com/datasets/shivamb/machine-predictive-maintenance-classification).
2. Download the ZIP file, extract it, and rename it to exactly `predictive_maintenance.csv` if it isn't already.
3. Place `predictive_maintenance.csv` into your `NP/data/raw/` folder!

### Step 2: Install Packages 
Open R and run:
```R
install.packages(readLines("requirements.txt"))
```

### Step 3: Execute the Entire Pipeline Sequence
We have explicitly mapped out the sequence. You can simply run the master script `run.R` which sequences them perfectly.
```R
source("scripts/run.R")
```

*(If you want to run them manually to observe output, run them in this EXACT sequence):*
1. `source("scripts/utils.R")`
2. `source("scripts/data_preprocessing.R")`
3. `source("scripts/feature_engineering.R")`
4. `source("scripts/train_model.R")`
5. `source("scripts/evaluate_model.R")`
6. `source("scripts/visualization.R")`
