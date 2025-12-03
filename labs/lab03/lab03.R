# ==============================================================================
# LABORATORIO 3: Vectores Autorregresivos (VAR)
# ==============================================================================
# Limpiar espacio de trabajo
rm(list = ls())

library(vars)
library(tidyverse)
library(forecast) # Para funciones de pronóstico

# ------------------------------------------------------------------------------
# 1. Preparación de Datos Multivariados
# ------------------------------------------------------------------------------

data(Canada) 
# Empleo, Productividad, Salarios Reales
var_data <- diff(Canada[, c("e", "prod", "rw")]) 

# ------------------------------------------------------------------------------
# 3. Estimación del VAR
# ------------------------------------------------------------------------------
# Estimación del modelo VAR con la librería
var_model <- VAR(var_data, p = 2, type = "const")

# Muestra las ecuaciones individuales. Explicar R-cuadrado y significancia.
summary(var_model)

# ------------------------------------------------------------------------------
# 4. Pronósticos (Forecasting)
# ------------------------------------------------------------------------------

# Generar pronósticos a partir del modelo VAR estimado
var_forecast <- predict(var_model, n.ahead = 8, ci = 0.95)
# n.ahead: número de períodos a pronosticar
# ci: nivel de confianza para los intervalos de predicción
# Visualizar los pronósticos
plot(var_forecast)


# ------------------------------------------------------------------------------
# 5. Visualización Combinada (Historia + Pronóstico)
# Utlizamos ggplot2 para una mejor visualización, pero más compleja.
# ------------------------------------------------------------------------------

# 1. Datos Históricos
hist_df <- data.frame(var_data)
hist_df$Time <- as.numeric(time(var_data)) # Extraer tiempo numérico
hist_df$Type <- "Observado"

# Convertir a formato largo
hist_long <- hist_df %>%
  pivot_longer(cols = -c(Time, Type), names_to = "Variable", values_to = "Value") %>%
  mutate(Lower = NA, Upper = NA) # No hay intervalos para historia

# 2. Datos de Pronóstico
# Calcular el vector de tiempo futuro
last_time <- max(hist_df$Time)
freq <- frequency(var_data)
n_ahead <- 8 # Debe coincidir con el n.ahead usado en predict()
future_times <- last_time + (1:n_ahead)/freq

# Procesar la lista de pronósticos
fcst_list <- list()
for(var in names(var_forecast$fcst)){
  mat <- var_forecast$fcst[[var]]
  df <- data.frame(
    Time = future_times,
    Type = "Pronóstico",
    Variable = var,
    Value = mat[,"fcst"],
    Lower = mat[,"lower"],
    Upper = mat[,"upper"]
  )
  fcst_list[[var]] <- df
}
fcst_long <- do.call(rbind, fcst_list)

# 3. Combinar
plot_data <- rbind(
  hist_long[, c("Time", "Type", "Variable", "Value", "Lower", "Upper")],
  fcst_long
)

# 4. Graficar
ggplot(plot_data, aes(x = Time, y = Value, color = Type)) +
  geom_line() +
  geom_ribbon(data = subset(plot_data, Type == "Pronóstico"), 
              aes(ymin = Lower, ymax = Upper, fill = Type), 
              alpha = 0.2, color = NA) +
  facet_wrap(~ Variable, scales = "free_y", ncol = 1) +
  labs(title = "Pronóstico VAR: Historia vs Predicción",
       subtitle = "Intervalos de confianza del 95%",
       x = "Tiempo", y = "Valor (Diferenciado)") +
  theme_minimal() +
  scale_color_manual(values = c("Observado" = "black", "Pronóstico" = "blue")) +
  scale_fill_manual(values = c("Pronóstico" = "blue"))







