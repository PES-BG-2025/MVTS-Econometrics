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

# ------------------------------------------------------------------------------
# 6. Simulación: Media y Varianza Condicional AR(1)
# ------------------------------------------------------------------------------
# Modelo: y_t = phi * y_{t-1} + epsilon_t

phi <- 0.7
sigma <- 1
y <- rep(0, 1000)

# Replicamos un proceso AR(1)
set.seed(999)
eps <- rnorm(1000, mean=0, sd=sigma)
y[1] <- eps[1]
for (t in 2:1000) {
   y[t] = phi * y[t-1] + eps[t]
}

# Calcular momentos incondicionales empíricos
media_empirica <- mean(y)
var_empirica <- var(y)

# Valores teóricos
media_teorica <- 0                      # (E(epsilon_t)) / phi
var_teorica <- sigma^2 / (1 - phi^2)    # Var(epsilon_t) / (1 - phi^2)

# Propiedades del modelo AR(1)
cat("Media Teórica:", media_teorica, "\n")
cat("Media Empírica:", media_empirica, "\n")
cat("Varianza Teórica:", var_teorica, "\n")
cat("Varianza Empírica:", var_empirica, "\n")

# Visualización de la distribución condicional
hist(y, 
    breaks = 30, 
    col = "lightblue", 
    border = "white",
    main = paste("Distribución de y_t"),
    xlab = "Posibles valores de y_t")

abline(v = media_teorica, col = "red", lwd = 2, lty = 2)
legend("topright", legend = c("Media incondicional"), col = c("red"), lty = 2)
