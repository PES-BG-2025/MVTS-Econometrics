library(vars)
library(tidyverse)
library(readxl)

# --- PASO 1: Carga de datos

xlsdata <- read_excel(
  path = "labs/lab04/BQ1989_Data.xlsx",
  sheet = "BQ1989",
  skip = 1)

vardata <- ts(xlsdata[,c("dy", "u")], start = c(1948, 2), frequency = 4)

plot.ts(vardata, main = "Crecimiento del PIB y Desempleo")


# --- PASO 2: Estimación del VAR y Verificación de Estabilidad ---

# Blanchard y Quah utilizan 8 rezagos
p_bq <- 8

# Estimación del VAR básico
var_est <- VAR(vardata, p = p_bq, type = "const")

# Verificar estabilidad (Raíces < 1)
# Si hay raíces fuera, BQ no funciona bien porque la matriz de respuesta
# acumulada de largo plazo explota.
roots(var_est)


# --- PASO 3: Imponer Restricción de Largo Plazo ---

# La función BQ() de la librería vars impone la restricción de que el elemento
# superior derecho de la matriz de largo plazo sea cero.

# La Lógica de la Matriz: El orden de las variables importa:
# Variable 1 (dy): Queremos que sea afectada por ambos shocks a corto plazo,
# pero solo por uno a largo plazo.
# Variable 2 (u): Afectada por ambos siempre.

# Aplicar Blanchard-Quah
svar_bq <- BQ(var_est)

# Al usar BQ(), R asume que el segundo shock no tiene efecto a largo plazo sobre
# la primera variable acumulada.
# 
# Variable 1 = Crecimiento PIB (Su acumulado es Nivel PIB). 
# Shock 2 = Shock de Demanda. 
# Restricción: El Shock de Demanda tiene efecto 0 a # largo plazo sobre el 
# Nivel del PIB.

# Ver la matriz de impacto contemporáneo estimada
summary(svar_bq)

# Notar que ¡la matriz de impacto ya no es triangular!
# Esto es porque BQ impone restricciones en largo plazo, no en corto plazo.


# --- PASO 4: Gráficas de Impulso-Respuesta ---

# Si la identificación funcionó, deberíamos ver lo siguiente:
# - Shock de Oferta $\to$ PIB: El efecto se acumula y se queda estable (permanente).
# - Shock de Demanda $\to$ PIB: El efecto sube y luego regresa a cero (transitorio).

# A. Shock de OFERTA (Shock 1) sobre el Nivel del PIB
# Nota: "cumulative = TRUE" aquí porque estimamos el VAR en diferencias (dy)
# pero queremos ver el efecto en el NIVEL del PIB.
irf_oferta_pib <- irf(svar_bq, impulse = "dy", response = "dy", 
                      cumulative = TRUE, n.ahead = 40, boot = TRUE)
# B. Shock de DEMANDA (Shock 2) sobre el Nivel del PIB
irf_demanda_pib <- irf(svar_bq, impulse = "u", response = "dy", 
                       cumulative = TRUE, n.ahead = 40, boot = TRUE)

# Computamos también las respuestas del desempleo ante choques de oferta y demanda
# Notar que en este caso, no acumulamos la respuesta
irf_oferta_u <- irf(svar_bq, impulse = "dy", response = "u", 
                      cumulative = FALSE, n.ahead = 40, boot = TRUE)

irf_demanda_u <- irf(svar_bq, impulse = "u", response = "u", 
                       cumulative = FALSE, n.ahead = 40, boot = TRUE)

# Graficar
plot(irf_oferta_pib, main = "Shock Oferta -> Nivel PIB (Permanente)")
plot(irf_demanda_pib, main = "Shock Demanda -> Nivel PIB (Transitorio)")

plot(irf_oferta_u, main = "Shock Oferta -> Desempleo (Transitorio)")
plot(irf_demanda_u, main = "Shock Demanda -> Desempleo (Transitorio")


# --- EJERCICIO ---

# Observe el gráfico de la derecha (Demanda -> PIB). 

# ¿Converge la línea a cero o a un valor distinto? Si converge a cero (o el
# intervalo de confianza incluye el cero a largo plazo), se cumple la hipótesis
# de la neutralidad del dinero/demanda.



## Nice plots

# Respuestas sobre el nivel del PIB
irfs_y <- irf(
  svar_bq, 
  response = "dy", 
  cumulative = TRUE,
  n.ahead = 40, 
  boot = TRUE)
# Respuestas sobre tasa de desempleo
irfs_u <- irf(
  svar_bq, 
  response = "u", 
  cumulative = FALSE,
  n.ahead = 40, 
  boot = TRUE)

# Función para extraer datos de IRF
source("labs/lab02/fn_IRF.R")

# Extraer IRFs como un dataframe
irf_y_df <- extract_irf_data(irfs_y)
irf_u_df <- extract_irf_data(irfs_u)

# Respuestas sobre y
ggplot(irf_y_df, aes(x = Period, y = Value)) +
  geom_line(color = "#2c3e50", linewidth = 0.8) +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), fill = "#3498db", alpha = 0.2) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  facet_grid(Response ~ Impulse, scales = "free_y", switch = "y") +
  labs(title = "Matriz de Funciones Impulso-Respuesta",
       subtitle = "Columnas: Shock (Impulso) | Filas: Variable de Respuesta",
       x = "Periodos", y = NULL) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "#ecf0f1"),
        strip.text = element_text(face = "bold"))

# Respuestas sobre u
ggplot(irf_u_df, aes(x = Period, y = Value)) +
  geom_line(color = "#2c3e50", linewidth = 0.8) +
  geom_ribbon(aes(ymin = Lower, ymax = Upper), fill = "#3498db", alpha = 0.2) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  facet_grid(Response ~ Impulse, scales = "free_y", switch = "y") +
  labs(title = "Matriz de Funciones Impulso-Respuesta",
       subtitle = "Columnas: Shock (Impulso) | Filas: Variable de Respuesta",
       x = "Periodos", y = NULL) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "#ecf0f1"),
        strip.text = element_text(face = "bold"))
