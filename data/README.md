# Data

This folder contains datasets used in the course.

## Structure

- **`raw/`**: Original, unmodified datasets as obtained from sources
- **`processed/`**: Cleaned and processed datasets ready for analysis
- **`examples/`**: Sample datasets for demonstrations and quick examples

## Data Sources

When adding datasets, please document:
- Source and URL
- Date of acquisition
- Description of variables
- Any preprocessing steps applied

## File Formats

Preferred formats:
- `.csv` - Comma-separated values for tabular data
- `.rds` - R data serialization for processed R objects
- `.xlsx` - Excel files (when necessary)

## Usage

To load data in R:
```r
# For CSV files
data <- read.csv("data/raw/dataset.csv")

# For RDS files
data <- readRDS("data/processed/dataset.rds")
```

## Data Documentation

Each dataset should ideally have an accompanying data dictionary or README file explaining:
- Variable names and descriptions
- Units of measurement
- Time period covered
- Any missing values or special codes
