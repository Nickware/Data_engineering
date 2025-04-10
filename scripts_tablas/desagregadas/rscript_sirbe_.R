# ───────────────────────────────────────────────
# Script para procesar y graficar datos de vejez por tipo de vivienda (SIRBE - SDIS)
# ───────────────────────────────────────────────

# Cargar librerías necesarias
library(dplyr)
library(readr)
library(openxlsx)
library(ggplot2)

# Establecer directorio de trabajo
setwd("/tmp/SDIS_SIRBE")

# Cargar base de datos
archivo <- "database/CargueSIRBEVejez.csv"
if (!file.exists(archivo)) stop("El archivo CSV no se encuentra en la ruta especificada.")
base_sdis <- read_csv(archivo)

# Crear tabla de frecuencia cruzada
Frecuencia <- table(base_sdis$NOMTENVIV, base_sdis$EDAD_ACTUAL)
df_frecuencia <- as.data.frame.matrix(Frecuencia)

# Definir rangos etarios
edades <- as.numeric(colnames(df_frecuencia))
rango_otros    <- edades[edades < 60]
rango_temprana <- edades[edades >= 60 & edades <= 74]
rango_tardia   <- edades[edades >= 75]

# Extraer subconjuntos
df_otros    <- df_frecuencia[, colnames(df_frecuencia) %in% as.character(rango_otros)]
df_temprana <- df_frecuencia[, colnames(df_frecuencia) %in% as.character(rango_temprana)]
df_tardia   <- df_frecuencia[, colnames(df_frecuencia) %in% as.character(rango_tardia)]

# Calcular totales y porcentajes
procesar_tabla <- function(df_rango) {
  total <- rowSums(df_rango)
  porcentaje <- round(100 * total / sum(total), 2)
  tabla <- data.frame("TipoVivienda" = rownames(df_rango), "Total" = total, "Porcentaje" = porcentaje)
  return(tabla)
}

tabla_otros    <- procesar_tabla(df_otros)
tabla_temprana <- procesar_tabla(df_temprana)
tabla_tardia   <- procesar_tabla(df_tardia)

# 📊 Función para generar gráfico de barras
graficar_tabla <- function(tabla, titulo, nombre_archivo) {
  p <- ggplot(tabla, aes(x = reorder(TipoVivienda, Total), y = Total)) +
    geom_bar(stat = "identity", fill = "#2a9d8f") +
    coord_flip() +
    labs(title = titulo, x = "Tipo de Vivienda", y = "Total") +
    theme_minimal(base_size = 12)
  
  ggsave(filename = paste0("tablas/", nombre_archivo, ".png"), plot = p, width = 8, height = 5)
  return(paste0("tablas/", nombre_archivo, ".png"))
}

# Generar gráficos y guardarlos
dir.create("tablas", showWarnings = FALSE)
img_otros    <- graficar_tabla(tabla_otros,    "Otros (<60 años)", "grafico_otros")
img_temprana <- graficar_tabla(tabla_temprana, "Vejez Temprana (60–74)", "grafico_temprana")
img_tardia   <- graficar_tabla(tabla_tardia,   "Vejez Tardía (75+)", "grafico_tardia")

# Crear archivo Excel con tablas y gráficos
wb <- createWorkbook()

agregar_hoja <- function(nombre, tabla, imagen) {
  addWorksheet(wb, nombre)
  writeData(wb, nombre, tabla)
  insertImage(wb, nombre, imagen, startRow = nrow(tabla) + 4, startCol = 1, width = 6, height = 4, units = "in")
}

agregar_hoja("Otros (<60 años)", tabla_otros, img_otros)
agregar_hoja("Vejez Temprana (60–74)", tabla_temprana, img_temprana)
agregar_hoja("Vejez Tardía (75+)", tabla_tardia, img_tardia)

# Guardar el archivo Excel
saveWorkbook(wb, file = "tablas/resumen_vejez_con_graficos.xlsx", overwrite = TRUE)

# Mensaje final
cat("✔️ Archivo Excel y gráficos generados con éxito en la carpeta 'tablas'.\n")
