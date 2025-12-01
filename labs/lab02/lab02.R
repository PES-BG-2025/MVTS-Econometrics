# ==============================================================================
# LABORATORIO 2 y 3: Vectores Autorregresivos (VAR)
# ==============================================================================
# Limpiar espacio de trabajo
rm(list = ls())

library(vars)
library(tidyverse)

# ------------------------------------------------------------------------------
# 1. Preparación de Datos Multivariados
# ------------------------------------------------------------------------------

# Simularemos un sistema VAR de 3 variables: PIB, Inflación, Tasa de Interés

data(Canada) # Dataset clásico incluido en R
var_data <- Canada[, c("e", "prod", "rw")] # Empleo, Productividad, Salarios Reales
colnames(var_data) <- c("Empleo", "Prod", "Salarios")

plot.ts(var_data, main = "Dinámica Multivariada")
plot.ts(diff(var_data), main = "Dinámica Multivariada")

# IMPORTANTE: En un VAR estándar, asumimos que las series son Estacionarias.
# Si no lo son, se deberían diferenciar primero (o usar VEC, que veremos la otra semana).
# Para este ejemplo, asumiremos que ya están transformadas/estacionarias.

# ------------------------------------------------------------------------------
# 2. Selección de Rezagos (Lag Selection)
# ------------------------------------------------------------------------------
# ¿Cuántos rezagos (p) debe tener el VAR?
lag_selection <- VARselect(var_data, lag.max = 8, type = "const")
lag_selection$selection

# TIP:
# AIC tiende a sobreestimar p (mejor para pronóstico).
# SC (BIC) tiende a subestimar p (mejor para inferencia/parsimonia).
# Usaremos p = 2 para el ejemplo.

# ------------------------------------------------------------------------------
# 3. Estimación del VAR
# ------------------------------------------------------------------------------
var_model <- VAR(var_data, p = 2, type = "const")

summary(var_model)
# Muestra las ecuaciones individuales. Explicar R-cuadrado y significancia.

# ------------------------------------------------------------------------------
# 4. Diagnóstico del Modelo (Validación)
# ------------------------------------------------------------------------------
# A. Estabilidad (Raíces del polinomio característico)
# Todas las raíces deben estar dentro del círculo unitario (< 1)
roots(var_model) 

# B. Autocorrelación serial en los residuos (Portmanteau Test)
# H0: No hay autocorrelación serial
serial_test <- serial.test(var_model, lags.pt = 10, type = "PT.asymptotic")
serial_test

# C. Normalidad de los residuos
norm_test <- normality.test(var_model)
norm_test

# ------------------------------------------------------------------------------
# 5. Análisis Estructural (Día 3 - Lo más importante)
# ------------------------------------------------------------------------------

# A. Causalidad de Granger
# ¿Ayuda la variable 'Salarios' a predecir 'Empleo'?
granger_cause <- causality(var_model, cause = "Salarios")
granger_cause

# B. Funciones de Impulso-Respuesta (IRF)
# ¿Cómo reacciona el 'Empleo' ante un shock en 'Prod' (Productividad)?
# n.ahead = periodos hacia adelante
# boot = TRUE genera intervalos de confianza (Bootstrapping)

irf_prod_emp <- irf(var_model, 
                    impulse = "Prod",    # Variable donde ocurre el shock
                    response = "Empleo", # Variable que responde
                    n.ahead = 10, 
                    boot = TRUE,
                    ortho = TRUE)        # Ortogonalización (Cholesky)

# Graficar
plot(irf_prod_emp, main = "Respuesta del Empleo ante Shock en Productividad")

# TIP:
# Explicar que si el intervalo (líneas punteadas) incluye el 0, 
# el efecto NO es estadísticamente significativo en ese periodo.

# C. Descomposición de Varianza (FEVD)
# ¿Qué porcentaje de la varianza del error de pronóstico de 'Empleo'
# se debe a sí mismo vs. a shocks en 'Prod' o 'Salarios'?
fevd_model <- fevd(var_model, n.ahead = 10)
plot(fevd_model)

# Ver los valores numéricos
print(fevd_model$Empleo)