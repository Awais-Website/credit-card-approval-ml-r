library(earth)
library(ggplot2)

## LOADING DATA
# Using relative path - assumes data file is in same directory
bankData <- read.csv("Student Data 5.csv")

## DEFINING K-FOLD CROSS VALIDATION FUNCTION
getBankDataKFoldRMSE <- function(model) {
  set.seed(354987)
  k <- 5
  folds <- floor(runif(nrow(bankData)) * k) + 1
  mean(sapply(1:k, function(i) {
    fit  <- update(model, data = bankData[folds != i, ])
    pred <- predict(fit, bankData[folds == i, ])
    sqrt(mean((pred - bankData$card[folds == i])^2))
  }))
}

## DEFINING 30+ MODEL FORMULAS (WITHOUT EXPENDITURE)
formulas <- list(
  card ~ reports + age,
  card ~ age + months,
  card ~ income + owner,
  card ~ selfemp + dependents,
  card ~ reports + age + income,
  card ~ income + owner + majorcards,
  card ~ reports + active,
  card ~ share + months + majorcards,
  card ~ reports + share + dependents,
  card ~ age + income + owner + active,
  card ~ reports + age + owner,
  card ~ age + owner + months,
  card ~ share + owner + majorcards,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + majorcards + active,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + majorcards,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + active,
  card ~ age + reports + income + share + selfemp + owner + dependents + majorcards + active,
  card ~ age + reports + income + share + selfemp + owner + months + majorcards + active,
  card ~ age + reports + income + share + selfemp + dependents + months + majorcards + active,
  card ~ age + reports + income + share + owner + dependents + months + majorcards + active,
  card ~ age + reports + income + selfemp + owner + dependents + months + majorcards + active,
  card ~ age + reports + share + selfemp + owner + dependents + months + majorcards + active,
  card ~ age + share + selfemp + owner + dependents + months + majorcards + active,
  card ~ reports + income + share + selfemp + owner + dependents + months + majorcards + active,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + active,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + majorcards,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + majorcards + active,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + majorcards,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + active,
  card ~ age + reports + income + share + selfemp + owner + dependents + months + majorcards + active
)

## RUNNING ALL MODELS (LM AND MARS)
results_grid <- data.frame(Model = character(), RMSE = numeric(), Type = character(), stringsAsFactors = FALSE)
for(f in formulas) {
  cat("RUNNING:", deparse(f), "[LM]\n")
  rmse_lm <- getBankDataKFoldRMSE(lm(f, data = bankData))
  results_grid <- rbind(results_grid, data.frame(Model = deparse(f), RMSE = rmse_lm, Type = "LM", stringsAsFactors = FALSE))
  
  cat("RUNNING:", deparse(f), "[MARS]\n")
  rmse_mars <- getBankDataKFoldRMSE(earth(f, data = bankData, degree = 2, thresh = 0.001))
  results_grid <- rbind(results_grid, data.frame(Model = deparse(f), RMSE = rmse_mars, Type = "MARS", stringsAsFactors = FALSE))
}

## PRINTING ALL RESULTS
print(results_grid)

## VISUALIZING RMSE OF ALL MODELS
ggplot(results_grid, aes(x = reorder(Model, RMSE), y = RMSE, fill = Type)) +
  geom_col(position = "dodge") +
  coord_flip() +
  labs(title = "RMSE ACROSS 30+ MODELS", x = "MODEL", y = "5-FOLD RMSE") +
  theme_minimal(base_size = 11)

## RUNNING BASELINE AND TUNED MODEL COMPARISON
baseA <- lm(card ~ selfemp + owner, data = bankData)
baseB <- lm(card ~ expenditure + age, data = bankData)

# Check if MyModels.RData exists before loading
if (file.exists("MyModels.RData")) {
  load("MyModels.RData")
  comparison <- data.frame(
    Model = c("BASELINE_A", "TUNED_A", "BASELINE_B", "TUNED_B"),
    RMSE = c(
      getBankDataKFoldRMSE(baseA),
      getBankDataKFoldRMSE(model1A),
      getBankDataKFoldRMSE(baseB),
      getBankDataKFoldRMSE(model1B)
    ),
    stringsAsFactors = FALSE
  )
  comparison$Improvement <- c(
    NA,
    (comparison$RMSE[1] - comparison$RMSE[2]) / comparison$RMSE[1] * 100,
    NA,
    (comparison$RMSE[3] - comparison$RMSE[4]) / comparison$RMSE[3] * 100
  )
  print(comparison)
  
  ## VISUALIZING BASELINE VS TUNED RESULTS
  ggplot(comparison, aes(x = Model, y = RMSE, fill = Model)) +
    geom_col(width = 0.6, color = "black") +
    geom_text(aes(label = sprintf("%.3f", RMSE)), vjust = -0.4, size = 4) +
    labs(title = "BASELINE VS TUNED MODEL RMSE", x = "", y = "5-FOLD RMSE") +
    theme_minimal(base_size = 13) +
    theme(legend.position = "none")
} else {
  cat("MyModels.RData not found. Skipping baseline vs tuned comparison.\n")
  cat("Baseline models RMSE:\n")
  cat("BASELINE_A:", getBankDataKFoldRMSE(baseA), "\n")
  cat("BASELINE_B:", getBankDataKFoldRMSE(baseB), "\n")
}

