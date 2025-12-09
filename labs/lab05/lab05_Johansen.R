# ==============================================================================
# LABORATORIO 5: Cointegración y Modelos VEC
# ==============================================================================
# Limpiar espacio de trabajo
rm(list = ls())

library(vars)
library(urca)
library(readxl)
library(tidyverse)

rm(list = ls())
graphics.off()

# 0. Carga de datos
# 'datos_vec' tiene nuestras 3 variables I(1)
datos_vec <- read_excel("labs/lab05/Coint6.38140536.xls")
datos_vec

# Graficar series I(1)
plot.ts(datos_vec)


## Preparar datos (Matriz o Dataframe)

# IMPORTANTE: Seleccionar tipo de tendencia (const, trend, both, none)
# 'datos_vec' tiene 3 variables I(1)

# Estimación del VAR en niveles
var_levels <- VAR(datos_vec, type = "const", lag.max = 8, ic = "AIC")
# Orden sugerido por AIC
var_levels$p

# K = número de rezagos (basado en VARselect sobre niveles - 1)

johansen_test <- ca.jo(datos_vec, 
                       type = "trace",    # Usualmente "trace" es el estándar
                       ecdet = "const",   # Constante en la relación de cointegración
                       K = var_levels$p,  # Rezagos (del VAR en niveles, = 2)
                       spec = "longrun")  # Especificación de largo plazo

# El test evalúa el rango (r) de la matriz, que equivale al número de relaciones de cointegración.

# Paso, Hipótesis Nula (H0),  Significado Económico

# 1,    r=0,    No existe ninguna relación de largo plazo (variables independientes).
# 2,    r≤1,    Existe máximo 1 relación de cointegración.
# 3,    r≤2,    Existen máximo 2 relaciones de cointegración.

summary(johansen_test)

# Miramos la columna test (el estadístico de prueba)
# Comparamos contra los valores críticos. 
# Si el estadístico > Valor crítico, entonces se rechaza H0 (y revisamos las otras entradas)

# Resultado: Nos quedamos con $r=1$. 
# Por lo tanto, para el resto del análisis, solo nos importa la primera columna 
# de las matrices siguientes.


## Estimación del VECM

# Si el test sugiere que r = 1:
vec_model <- cajorls(johansen_test, r = 1)

# Ver los coeficientes
print(vec_model)

# La salida tiene dos partes:
# 1. RLM (Restricted Long Run): El vector beta (la ecuación de largo plazo)
# 2. B (Beta): Los coeficientes de ajuste (alpha)


# Transformar VEC a VAR para obtener funciones de impulso respuesta
var_from_vec <- vec2var(johansen_test, r = 1)
var_from_vec

# Ahora sí podemos usar las herramientas de la semana pasada
irf_vec <- irf(var_from_vec, 
               impulse = "w", 
               response = "y", 
               n.ahead = 20, 
               boot = TRUE)

plot(irf_vec)

# Una diferencia importante es que las funciones de impulso respuesta en un VAR 
# cointegrado no necesariamente se aproximan a cero porque las variables no 
# son estacionarias


## Estimación del VECM con tsDyn

# También es posible estimar el VECM por máxima verosimilitud con la librería tsDyn

library(tsDyn)
vec_tsdyn <- VECM(datos_vec, lag = 1, r = 1, include = "none", estim = "ML") 
summary(vec_tsdyn)
