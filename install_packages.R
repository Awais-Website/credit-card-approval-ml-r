# Install required packages for Credit Card Approval Project
required_packages <- c("earth", "ggplot2")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

cat("All required packages installed and loaded!\n")

