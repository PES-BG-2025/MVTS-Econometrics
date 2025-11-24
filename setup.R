# Setup Script for MVTS-Econometrics Course
# Run this script once to install all required R packages

# ============================================================================
# PACKAGE INSTALLATION
# ============================================================================

cat("Installing required packages for MVTS-Econometrics course...\n\n")

# List of required packages
required_packages <- c(
  # Core time series packages
  "vars",           # VAR modeling
  "urca",           # Unit root and cointegration tests
  "tseries",        # Time series analysis and tests
  "forecast",       # Forecasting methods
  "zoo",            # Infrastructure for time series
  "xts",            # Extensible time series
  
  # Additional econometrics packages
  "dynlm",          # Dynamic linear models
  "lmtest",         # Testing linear regression models
  "sandwich",       # Robust covariance matrix estimators
  "strucchange",    # Testing for structural change
  "tsDyn",          # Nonlinear time series models
  
  # GARCH models
  "rugarch",        # Univariate GARCH models
  "rmgarch",        # Multivariate GARCH models
  
  # Data manipulation and visualization
  "dplyr",          # Data manipulation
  "tidyr",          # Data tidying
  "readr",          # Reading data files
  "readxl",         # Reading Excel files
  "ggplot2",        # Advanced plotting
  "gridExtra",      # Arranging multiple plots
  
  # Additional utilities
  "car",            # Companion to Applied Regression
  "MASS",           # Modern Applied Statistics
  "knitr",          # Dynamic report generation
  "rmarkdown"       # R Markdown documents
)

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  
  if(length(new_packages) > 0) {
    cat("Installing:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, dependencies = TRUE)
  } else {
    cat("All packages are already installed!\n")
  }
}

# Install packages
install_if_missing(required_packages)

# ============================================================================
# VERIFICATION
# ============================================================================

cat("\n\nVerifying installation...\n\n")

# Check if all packages are installed correctly
failed_packages <- c()

for (pkg in required_packages) {
  tryCatch({
    find.package(pkg)
  }, error = function(e) {
    failed_packages <<- c(failed_packages, pkg)
  })
}

# Report results
if (length(failed_packages) == 0) {
  cat("SUCCESS! All packages installed and loaded correctly.\n")
  cat("You are ready to start the course!\n")
} else {
  cat("WARNING: The following packages failed to install:\n")
  cat(paste(failed_packages, collapse = ", "), "\n")
  cat("\nTry installing them manually with:\n")
  cat("install.packages(c(\n")
  cat(paste0("  '", failed_packages, "'", collapse = ",\n"))
  cat("\n))\n")
}

# ============================================================================
# R VERSION INFO
# ============================================================================

cat("\n\nYour R configuration:\n")
cat("R version:", R.version.string, "\n")
cat("Platform:", R.version$platform, "\n")

# Check R version
if (as.numeric(R.version$major) >= 4) {
  cat("Your R version is suitable for the course.\n")
} else {
  cat("WARNING: R version 4.0.0 or higher is recommended.\n")
  cat("Consider updating R from: https://cran.r-project.org/\n")
}

# ============================================================================
# NEXT STEPS
# ============================================================================

cat("\n\nNext steps:\n")
cat("1. Check the 'lectures/' folder for course slides\n")
cat("2. Start with 'labs/lab01/' for your first practical session\n")
cat("3. Refer to the README.md for course structure and information\n")
cat("\nHappy learning!\n")
