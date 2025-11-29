# Lab 01: Introducción a R para Análisis de Series de Tiempo
# Econometría de Series de Tiempo Multivariadas
# Ejemplo de Sesión de Laboratorio

# ============================================================================
# OBJETIVOS
# ============================================================================
# 1. Revisar operaciones básicas de R y estructuras de datos
# 2. Aprender a importar y manipular datos de series de tiempo
# 3. Crear gráficos básicos de series de tiempo
# 4. Entender los objetos ts y xts en R

# ============================================================================
# CONFIGURACIÓN
# ============================================================================

# Limpiar espacio de trabajo
rm(list = ls())

# Cargar paquetes requeridos
# Si no están instalados, ejecute setup.R primero para instalar todos los paquetes requeridos
library(tseries)
library(xts)
library(zoo)
library(ggplot2)

# ============================================================================
# EJERCICIO 1: Creación de Objetos de Series de Tiempo
# ============================================================================

# Crear un objeto de serie de tiempo simple
# Ejemplo: Datos trimestrales desde 2020 Q1 hasta 2023 Q4

# Generar algunos datos de muestra
set.seed(123)
data_values <- rnorm(16, mean = 100, sd = 10)

# Crear un objeto ts
ts_data <- ts(data_values, start = c(2020, 1), frequency = 4)

# Mostrar la serie de tiempo
print(ts_data)

# Graficar la serie de tiempo
plot(ts_data, main = "Ejemplo de Serie de Tiempo Trimestral",
     xlab = "Tiempo", ylab = "Valor", col = "blue", lwd = 2)


# TODO: Cree su propia serie de tiempo con datos mensuales desde 2021 hasta 2023
# Su código aquí:



# ============================================================================
# EJERCICIO 2: Propiedades de las Series de Tiempo
# ============================================================================

# Verificar atributos de la serie de tiempo
start(ts_data)
end(ts_data)
frequency(ts_data)
time(ts_data)

# Calcular estadísticas básicas
summary(ts_data)
mean(ts_data)
sd(ts_data)

# TODO: Calcule el coeficiente de variación (sd/mean) para su serie de tiempo
# Su código aquí:



# ============================================================================
# EJERCICIO 3: Creación de Series de Tiempo Multivariadas
# ============================================================================

# Crear una serie de tiempo multivariada (dos variables)
var1 <- rnorm(20, mean = 50, sd = 5)
var2 <- rnorm(20, mean = 100, sd = 15)

# Combinar en un objeto ts multivariado
mts_data <- ts(cbind(var1, var2), start = c(2020, 1), frequency = 4)

# Graficar ambas series
plot(mts_data, main = "Ejemplo de Serie de Tiempo Multivariada")

# TODO: Cree una serie de tiempo multivariada con 3 variables
# Su código aquí:



# ============================================================================
# PREGUNTAS PARA DISCUSIÓN
# ============================================================================

# 1. ¿Cuál es la diferencia entre los objetos ts y xts?
# 
# Respuesta:
# Los objetos ts son objetos de series de tiempo base de R con frecuencia regular
# Los objetos xts son más flexibles y pueden manejar series de tiempo irregulares

# 2. ¿Por qué es importante especificar la frecuencia correcta al crear 
#    un objeto de serie de tiempo?
#
# Respuesta:
# La frecuencia determina cómo R interpreta los índices de tiempo y afecta
# a la descomposición estacional y los métodos de pronóstico

# ============================================================================
# RECURSOS ADICIONALES
# ============================================================================

# Funciones útiles para series de tiempo en R:
# - lag() : Crear versiones rezagadas de una serie de tiempo
# - diff() : Calcular diferencias
# - window() : Extraer un subconjunto de una serie de tiempo
# - decompose() : Descomposición estacional clásica

# Ejemplo de diferenciación
ts_diff <- diff(ts_data)
plot(ts_diff, main = "Primera Diferencia", col = "red")
