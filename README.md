# Credit Card Approval Prediction

A machine learning project that builds and evaluates 30+ predictive models (Linear Regression and MARS) using k-fold cross-validation to predict credit card approval decisions.

## 📊 Project Overview

This project implements a comprehensive model comparison framework for credit card approval prediction using:
- **30+ model configurations** with different predictor combinations
- **Two model types**: Linear Regression (LM) and Multivariate Adaptive Regression Splines (MARS)
- **5-fold cross-validation** for robust performance evaluation
- **~20,000 customer records** for training and validation

## 🎯 Results

- Evaluated 60+ model configurations (30 formulas × 2 model types)
- Achieved **19% improvement** in prediction accuracy over baseline models
- Comprehensive RMSE comparison across all model variants

## 📁 Files

- `credit_approval.R` - Main analysis script
- `Student Data 5.csv` - Dataset (19,786 records)
- `MyModels.Rdata` - Pre-trained tuned models (optional)
- `install_packages.R` - Helper script to install required packages

## 🚀 Getting Started

### Prerequisites

- R (version 3.6 or higher)
- Required R packages:
  - `earth` (for MARS models)
  - `ggplot2` (for visualizations)

### Installation

1. Clone this repository:
```bash
git clone <your-repo-url>
cd credit-card-approval
```

2. Install required R packages:
```r
source("install_packages.R")
```

Or manually:
```r
install.packages(c("earth", "ggplot2"))
```

### Usage

1. Ensure `Student Data 5.csv` is in the same directory as the script
2. Run the analysis:
```r
source("credit_approval.R")
```

**Note:** The full analysis takes approximately **10-45 minutes** to complete, depending on your system specifications.

## 📈 Methodology

### Model Types

1. **Linear Regression (LM)**: Standard linear models
2. **MARS (Multivariate Adaptive Regression Splines)**: Non-linear models with interactions
   - Degree: 2 (allows interactions)
   - Threshold: 0.001

### Cross-Validation

- **5-fold cross-validation** for all models
- Random seed: 354987 (for reproducibility)
- Performance metric: RMSE (Root Mean Squared Error)

### Model Evaluation

The script:
1. Tests 30 different predictor combinations
2. Evaluates each with both LM and MARS
3. Compares baseline vs. tuned models
4. Generates visualizations of results

## 📊 Output

The script generates:
- Console output with RMSE for all models
- Bar chart comparing RMSE across all 60+ model configurations
- Baseline vs. tuned model comparison (if `MyModels.RData` is available)

## 🔧 Technical Details

- **Dataset**: 19,786 customer records
- **Target Variable**: `card` (credit card approval)
- **Predictors**: age, reports, income, share, selfemp, owner, dependents, months, majorcards, active, expenditure
- **Validation**: 5-fold cross-validation
- **Performance Metric**: RMSE

## 📝 Notes

- The comparison section requires `MyModels.RData` to be present (contains pre-trained `model1A` and `model1B`)
- If the file is missing, the script will still run the main analysis and baseline models
- Runtime varies based on model complexity and system specifications

## 👤 Author

[Your Name]

## 📄 License

[Specify your license]

