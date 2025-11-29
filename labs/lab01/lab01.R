# ==============================================================================
# LABORATORIO 1: Introducción a Series de Tiempo y Modelos ARMA
# ==============================================================================

library(tidyverse)
library(tseries)  # Para tests de estacionariedad (ADF)
library(forecast) # Para auto.arima

# ------------------------------------------------------------------------------
# 1. Carga y Creación de Datos (Simulación)
# ------------------------------------------------------------------------------
# En la vida real: datos <- read.csv("mi_archivo.csv")
# Simulamos un proceso AR(1) para el ejemplo
set.seed(123)
n <- 200
y <- arima.sim(list(order = c(1,0,0), ar = 0.7), n = n)

# Convertir a objeto de serie de tiempo (ts)
# frequency = 4 (Trimestral), frequency = 12 (Mensual)
ts_y <- ts(y, start = c(2000, 1), frequency = 4)

# ------------------------------------------------------------------------------
# 2. Análisis Gráfico y Estacionariedad
# ------------------------------------------------------------------------------
# Graficar la serie
plot.ts(ts_y, main = "Evolución de la Variable Y", ylab = "Valor", col = "blue")
grid()

# Gráficos de Autocorrelación (ACF) y Autocorrelación Parcial (PACF)
# Sirven para intuir el orden p y q del ARMA
par(mfrow = c(1,2)) # Dividir pantalla en 2
acf(ts_y, main = "ACF (Media Móvil - q)")
pacf(ts_y, main = "PACF (Autoregresivo - p)")
par(mfrow = c(1,1)) # Regresar pantalla a normal

# Test Formal: Augmented Dickey-Fuller (ADF)
# H0: La serie TIENE raíz unitaria (No estacionaria)
# H1: La serie es estacionaria
adf_test <- adf.test(ts_y)
print(adf_test)

# TIP: Si p-value > 0.05, no rechazamos H0 -> Debemos diferenciar la serie.
# ts_y_diff <- diff(ts_y)

# ------------------------------------------------------------------------------
# 3. Estimación del Modelo ARMA
# ------------------------------------------------------------------------------
# Forma manual (si sospechamos un AR(1))
modelo_manual <- Arima(ts_y, order = c(1,0,0))

# Forma automática (Recomendada para benchmark)
# auto.arima busca el mejor modelo basado en AIC/BIC
modelo_auto <- auto.arima(ts_y, stationary = TRUE, seasonal = FALSE)

summary(modelo_auto)

# ------------------------------------------------------------------------------
# 4. Diagnóstico de Residuos
# ------------------------------------------------------------------------------
checkresiduals(modelo_auto)
# El test de Ljung-Box evalúa si queda "ruido blanco". 
# Buscamos p-value > 0.05 (No hay autocorrelación en los residuos).


# ------------------------------------------------------------------------------
# 5. Media y varianza incondicional del proceso
# ------------------------------------------------------------------------------

mean(ts_y)
var(ts_y)
