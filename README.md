# MVTS-Econometrics

Repositorio para el curso de Econometría IV (Series de tiempo multivariadas) del Programa de Estudios Superiores 2025-2026

## Descripción del Curso / Course Description

Este repositorio contiene todos los materiales del curso de Econometría de Series de Tiempo Multivariadas, incluyendo diapositivas de clases, laboratorios prácticos en R, conjuntos de datos y materiales de referencia.

This repository contains all materials for the Multivariate Time Series Econometrics course, including lecture slides, hands-on R laboratory sessions, datasets, and reference materials.

## Estructura del Repositorio / Repository Structure

```
MVTS-Econometrics/
│
├── lectures/          # Lecture slides and materials by week
│   ├── week01/       # Introduction to Multivariate Time Series and VAR Models
│   └── week02/       # Advanced Topics and Applications
│
├── labs/             # Laboratory sessions with R scripts
│   ├── lab01/        # Introduction to R for Time Series
│   ├── lab02/        # VAR Model Estimation and Diagnostics
│   ├── lab03/        # Impulse Response Analysis
│   ├── lab04/        # Cointegration Testing
│   ├── lab05/        # VECM Implementation
│   └── lab06/        # Advanced Applications and Project Work
│
├── data/             # Datasets used in the course
│   ├── raw/          # Original, unmodified datasets
│   ├── processed/    # Cleaned datasets ready for analysis
│   └── examples/     # Sample datasets for demonstrations
│
├── project/          # Course project materials
│                     # Guidelines, templates, and project-specific data
│
├── solutions/        # Solutions to laboratory exercises
│
└── references/       # Additional reading materials and papers
```

## Requisitos / Requirements

### Software
- **R** (version ≥ 4.0.0)
- **RStudio** (recommended IDE)

### Paquetes de R Principales / Main R Packages
```r
install.packages(c("vars", "urca", "tseries", "forecast", 
                   "ggplot2", "dplyr", "readr"))
```

## Cómo Usar Este Repositorio / How to Use This Repository

1. **Clona el repositorio / Clone the repository:**
   ```bash
   git clone https://github.com/PES-BG-2025/MVTS-Econometrics.git
   ```

2. **Navega a las carpetas relevantes / Navigate to relevant folders:**
   - `lectures/` para diapositivas / for slides
   - `labs/` para ejercicios de laboratorio / for lab exercises
   - `data/` para conjuntos de datos / for datasets
   - `solutions/` para soluciones (disponibles después de completar los ejercicios) / for solutions (available after completing exercises)

3. **Consulta los archivos README en cada carpeta para más información / Check README files in each folder for more information**

## Temas del Curso / Course Topics

This intensive 2-week course covers:

**Week 1:**
- Introduction to Multivariate Time Series
- Vector Autoregression (VAR) Models
- Impulse Response Functions
- Forecast Error Variance Decomposition

**Week 2:**
- Cointegration and Error Correction Models
- Vector Error Correction Models (VECM)
- Advanced Topics and Applications
- Course Project

**Laboratory Sessions:** 6 practical sessions with hands-on R implementation

## Contribuciones / Contributions

Este repositorio es mantenido por los instructores del curso. Los estudiantes pueden reportar errores o sugerir mejoras a través de issues.

This repository is maintained by the course instructors. Students can report errors or suggest improvements through issues.

## Licencia / License

Los materiales de este curso están disponibles para uso educativo.

Course materials are available for educational use.
