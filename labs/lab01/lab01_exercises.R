# Lab 01: Introduction to R for Time Series Analysis
# Multivariate Time Series Econometrics
# Example Laboratory Session

# ============================================================================
# OBJECTIVES
# ============================================================================
# 1. Review basic R operations and data structures
# 2. Learn to import and manipulate time series data
# 3. Create basic time series plots
# 4. Understand ts and xts objects in R

# ============================================================================
# SETUP
# ============================================================================

# Clear workspace
rm(list = ls())

# Load required packages
# install.packages(c("tseries", "xts", "zoo", "ggplot2"))  # Run if needed
library(tseries)
library(xts)
library(zoo)
library(ggplot2)

# ============================================================================
# EXERCISE 1: Creating Time Series Objects
# ============================================================================

# Create a simple time series object
# Example: Quarterly data from 2020 Q1 to 2023 Q4

# Generate some sample data
set.seed(123)
data_values <- rnorm(16, mean = 100, sd = 10)

# Create a ts object
ts_data <- ts(data_values, start = c(2020, 1), frequency = 4)

# Display the time series
print(ts_data)

# Plot the time series
plot(ts_data, main = "Example Quarterly Time Series",
     xlab = "Time", ylab = "Value", col = "blue", lwd = 2)


# TODO: Create your own time series with monthly data from 2021 to 2023
# Your code here:



# ============================================================================
# EXERCISE 2: Time Series Properties
# ============================================================================

# Check time series attributes
start(ts_data)
end(ts_data)
frequency(ts_data)
time(ts_data)

# Calculate basic statistics
summary(ts_data)
mean(ts_data)
sd(ts_data)

# TODO: Calculate the coefficient of variation (sd/mean) for your time series
# Your code here:



# ============================================================================
# EXERCISE 3: Creating Multivariate Time Series
# ============================================================================

# Create a multivariate time series (two variables)
var1 <- rnorm(20, mean = 50, sd = 5)
var2 <- rnorm(20, mean = 100, sd = 15)

# Combine into a multivariate ts object
mts_data <- ts(cbind(var1, var2), start = c(2020, 1), frequency = 4)

# Plot both series
plot(mts_data, main = "Multivariate Time Series Example")

# TODO: Create a multivariate time series with 3 variables
# Your code here:



# ============================================================================
# QUESTIONS FOR DISCUSSION
# ============================================================================

# 1. What is the difference between ts and xts objects?
# 
# Your answer:
# ts objects are base R time series objects with regular frequency
# xts objects are more flexible and can handle irregular time series

# 2. Why is it important to specify the correct frequency when creating 
#    a time series object?
#
# Your answer:
# Frequency determines how R interprets time indices and affects
# seasonal decomposition and forecasting methods

# ============================================================================
# ADDITIONAL RESOURCES
# ============================================================================

# Useful functions for time series in R:
# - lag() : Create lagged versions of a time series
# - diff() : Compute differences
# - window() : Extract a subset of a time series
# - decompose() : Classical seasonal decomposition

# Example of differencing
ts_diff <- diff(ts_data)
plot(ts_diff, main = "First Difference", col = "red")
