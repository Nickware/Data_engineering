# -------------------------------
# ANÁLISIS DE DATOS DE BENEFICIARIOS - SISTEMA SIRBE
# -------------------------------

## 1. Configuración inicial ----
# -------------------------------
# Carga de librerías
library(extrafont)    # Para manejo de fuentes
library(dplyr)        # Para manipulación de datos
library(scales)       # Para formato de porcentajes

# Configuración de directorio de trabajo
setwd("/tmp/SDIS_SIRBE/database/")

## 2. Carga y preparación de datos ----
# -------------------------------
# Cargar datos con manejo de errores
if(file.exists("CargueSIRBEVejez.csv")) {
  base_sdis <- read.csv("CargueSIRBEVejez.csv", header = TRUE, 
                       stringsAsFactors = FALSE, fileEncoding = "UTF-8")
} else {
  stop("El archivo CargueSIRBEVejez.csv no existe en el directorio especificado")
}

# Verificación básica de datos
if(!all(c("NOMACTUACION", "EDAD_ACTUAL") %in% colnames(base_sdis))) {
  stop("El dataset no contiene las columnas requeridas (NOMACTUACION, EDAD_ACTUAL)")
}

## 3. Procesamiento de datos ----
# -------------------------------
# Crear tabla de frecuencias con nombres descriptivos
frecuencia <- table(
  "Modalidad" = base_sdis$NOMACTUACION,
  "Edad" = base_sdis$EDAD_ACTUAL
)

# Calcular estadísticas resumen
resumen <- data.frame(
  Total = rowSums(frecuencia),
  Porcentaje = prop.table(rowSums(frecuencia))
) %>% 
  arrange(desc(Porcentaje))  # Ordenar por porcentaje descendente

## 4. Visualización de datos ----
# -------------------------------
# Configuración de gráfico
png(
  filename = "/tmp/grafica/grafica.png",
  width = 800, 
  height = 600, 
  units = "px",
  bg = "white",
  type = "cairo"
)

# Parámetros gráficos
par(
  family = "sans",       # Fuente legible
  mar = c(5, 12, 4, 2),  # Márgenes (abajo, izquierda, arriba, derecha)
  las = 1                # Orientación de etiquetas
)

# Crear gráfico de barras horizontales
bp <- barplot(
  height = resumen$Porcentaje,
  names.arg = rownames(resumen),
  horiz = TRUE,
  col = RColorBrewer::brewer.pal(nrow(resumen), "Blues"),
  border = NA,
  xlim = c(0, 1.1 * max(resumen$Porcentaje)),
  main = "Distribución de población beneficiaria\npor modalidad de atención",
  xlab = "Porcentaje de beneficiarios",
  cex.names = 0.8,
  axes = FALSE
)

# Añadir porcentajes
text(
  x = resumen$Porcentaje + 0.02,
  y = bp,
  labels = scales::percent(resumen$Porcentaje, accuracy = 1),
  pos = 4,
  cex = 0.8,
  col = "black"
)

# Añadir eje x personalizado
axis(1, at = seq(0, 1, 0.1), labels = scales::percent(seq(0, 1, 0.1)))

# Añadir cuadrícula
grid(nx = NA, ny = NULL, col = "gray90", lty = "dotted")

# Cerrar dispositivo gráfico
dev.off()

## 5. Exportación de resultados ----
# -------------------------------
# Guardar tabla de resumen
write.csv(
  resumen,
  file = "/tmp/grafica/resumen_estadistico.csv",
  row.names = TRUE,
  fileEncoding = "UTF-8"
)

# Mensaje de confirmación
message("Análisis completado exitosamente. Gráfico y datos exportados.")
