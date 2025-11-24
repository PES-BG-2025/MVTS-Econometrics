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
│   ├── week01/       # Introduction to Multivariate Time Series
│   ├── week02/       # Vector Autoregression (VAR) Models
│   ├── ...
│   └── week12/       # Advanced Topics and Applications
│
├── labs/             # Laboratory sessions with R scripts
│   ├── lab01/        # Introduction to R for Time Series
│   ├── lab02/        # VAR Model Estimation and Diagnostics
│   ├── ...
│   └── lab08/        # Advanced Applications
│
├── data/             # Datasets used in the course
│   ├── raw/          # Original, unmodified datasets
│   ├── processed/    # Cleaned datasets ready for analysis
│   └── examples/     # Sample datasets for demonstrations
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

1. Introduction to Multivariate Time Series
2. Vector Autoregression (VAR) Models
3. Impulse Response Functions
4. Forecast Error Variance Decomposition
5. Cointegration and Error Correction Models
6. Vector Error Correction Models (VECM)
7. Structural VAR Models
8. State Space Models
9. Multivariate GARCH Models
10. Factor Models and Dynamic Factor Models
11. Regime Switching Models
12. Advanced Topics and Applications

## Contribuciones / Contributions

Este repositorio es mantenido por los instructores del curso. Los estudiantes pueden reportar errores o sugerir mejoras a través de issues.

This repository is maintained by the course instructors. Students can report errors or suggest improvements through issues.

## Licencia / License

Los materiales de este curso están disponibles para uso educativo.

Course materials are available for educational use.
