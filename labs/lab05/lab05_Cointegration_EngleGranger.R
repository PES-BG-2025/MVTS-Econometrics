# ==============================================================================
# LABORATORIO 5: Cointegración y Metodología Engle-Granger (2 Pasos)
# ==============================================================================

# Objetivo: 
# 1. Entender que una regresión entre variables I(1) suele ser espuria.
# 2. Verificar cointegración analizando si los residuos son estacionarios.
# 3. Estimar el Modelo de Corrección de Errores (MCE/ECM).

library(tidyverse)
library(tseries) # Para adf.test y po.test
library(lmtest)  # Para coeftest

rm(list = ls())
graphics.off()

set.seed(999) # Semilla para replicabilidad


# ------------------------------------------------------------------------------
# 1. GENERACIÓN DE DATOS (El Laboratorio Controlado)
# ------------------------------------------------------------------------------
# Simularemos un sistema donde el Consumo depende del Ingreso a largo plazo.

n <- 200
# A. Variable Exógena: Ingreso (Caminata Aleatoria -> I(1))
ingreso <- cumsum(rnorm(n, mean = 0.5, sd = 1))

# B. Relación de Cointegración
# Consumo = 5 + 0.8*Ingreso + Error_Estacionario
error_equilibrio <- rnorm(n, sd = 2) # Ruido blanco I(0)
consumo <- 5 + 0.8 * ingreso + error_equilibrio 

# C. Variable NO Cointegrada (Un proceso ajeno/exógeno)
# Una serie I(1) que no tiene nada que ver con las anteriores
independiente <- cumsum(rnorm(n, mean = 0.5, sd = 1))

# Unir todo en un objeto ts
datos <- ts(data.frame(consumo, ingreso, independiente), start=c(2000,1), frequency=4)

# Gráfico Inicial
plot.ts(datos, main = "Series en niveles", col=c("blue", "black", "red"))


# ------------------------------------------------------------------------------
# PASO 0: Verificación del Orden de Integración
# ------------------------------------------------------------------------------
# Antes de Engle-Granger, debemos asegurar que ambas series sean I(1).
# Si una es I(0) y la otra I(1), NO pueden estar cointegradas.

adf.test(consumo) # p-value alto (>0.05) -> No rechazo H0 -> Tiene Raíz Unitaria
adf.test(ingreso) # p-value alto (>0.05) -> No rechazo H0 -> Tiene Raíz Unitaria

# Conclusión: Ambas son no estacionarias. Podemos proceder.


# ==============================================================================
# METODOLOGÍA ENGLE-GRANGER
# ==============================================================================

# ------------------------------------------------------------------------------
# PASO 1: La Regresión de Largo Plazo (Estática)
# ------------------------------------------------------------------------------
# Estimamos por OLS simple la relación en niveles.
# Modelo: Consumo_t = B0 + B1*Ingreso_t + u_t

modelo_lp <- lm(consumo ~ ingreso)
summary(modelo_lp)

# NOTA:
# En series de tiempo no estacionarias, los t-stat y p-values de esta regresión 
# NO SON CONFIABLES (están sesgados). 
# En este caso, solo nos interesan los coeficientes y los residuos para aplicar
# la metodología de Engle y Granger.

# ------------------------------------------------------------------------------
# PASO 2: Test de Estacionariedad en los Residuos
# ------------------------------------------------------------------------------
# Obtenemos los residuos
residuos_eg <- residuals(modelo_lp)

# Graficamos los residuos (Inspección Visual)
plot.ts(residuos_eg, main = "Residuos de la Regresión de Largo Plazo", ylab="Residuos")
abline(h=0, col="red")
# ¿Cruzan el cero frecuentemente? Si es así, parece que hay cointegración.

# Test Formal (ADF sobre residuos)
# H0: Los residuos tienen raíz unitaria (NO hay cointegración)
# H1: Los residuos son estacionarios (SÍ hay cointegración)
test_cointegracion <- adf.test(residuos_eg, k=1) # k bajo porque son residuos
print(test_cointegracion)

# INTERPRETACIÓN:
# Si p-value < 0.05 -> Rechazo H0. Los residuos son estacionarios.
# EXISTE COINTEGRACIÓN.



## --- CONTRAEJEMPLO (Regresión Espuria) ---
# Intentemos cointegrar Consumo con la variable 'Independiente'

# Recordemos en el proceso generador de datos, el consumo no depende de 
# la variable 'independiente'
modelo_falso <- lm(consumo ~ independiente)
adf.test(residuals(modelo_falso)) 

# p-value alto -> Los residuos se alejan de cero -> No hay relación.
residuos_nocoint <- residuals(modelo_falso)
plot.ts(residuos_nocoint, main = "Residuos de la Regresión Espuria", ylab="Residuos")

# Como se observa, los residuos ya no parecen estacionarios. 
# Es decir, 'Consumo' e 'Independiente' no están cointegradas, no hay una relación 
# de largo plazo entre ellas.



# ------------------------------------------------------------------------------
# PASO 3: Modelo de Corrección de Errores (MCE / ECM)
# ------------------------------------------------------------------------------
# Si pasamos el Paso 2, estimamos la dinámica de corto plazo.
# Ecuación: d(Consumo) = a*Residuos_t-1 + b*d(Ingreso) + error

# Preparar variables diferenciadas y rezagadas
d_consumo <- diff(consumo)
d_ingreso <- diff(ingreso)
# El residuo debe ser el del periodo anterior (t-1)
error_lag <- residuos_eg[-length(residuos_eg)] # Quitamos el último para alinear

# Ajustar longitudes (al diferenciar perdemos 1 obs)
# Creamos un dataframe temporal para alinear todo
data_ecm <- data.frame(
  d_consumo = as.numeric(d_consumo),
  d_ingreso = as.numeric(d_ingreso),
  error_correction_term = as.numeric(error_lag)
)

# Estimación del MCE
modelo_ecm <- lm(d_consumo ~ d_ingreso + error_correction_term - 1, data = data_ecm) 
# "-1" quita la constante, aunque a veces se deja si d_y tiene tendencia.

summary(modelo_ecm)

# ------------------------------------------------------------------------------
# INTERPRETACIÓN FINAL 
# ------------------------------------------------------------------------------
# Mira el coeficiente de 'error_correction_term' (alpha):
coef_ajuste <- coef(modelo_ecm)["error_correction_term"]
print(paste("Coeficiente de Velocidad de Ajuste:", round(coef_ajuste, 4)))

# 1. SIGNO: Debe ser NEGATIVO. (Si hay exceso de consumo hoy, mañana debe bajar).
# 2. SIGNIFICANCIA: Debe ser estadísticamente significativo (p < 0.05).
# 3. MAGNITUD: Entre 0 y -1 (o -2 en oscilaciones).
#    Ej: -0.25 significa que el 25% del desequilibrio se corrige en un trimestre.
