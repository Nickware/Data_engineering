# ---------------------------------------------
# ANÁLISIS DE FRECUENCIAS SDIS - VEJEZ
# ---------------------------------------------
# Este script carga una base de datos CSV con información de personas mayores,
# construye una tabla de frecuencia cruzada entre tipo de vivienda y edad actual,
# calcula totales y porcentajes por tipo de vivienda, exporta los resultados a un archivo Excel,
# y genera un gráfico de barras con los totales por tipo de vivienda.
# ---------------------------------------------

# Cargar solo la librería necesaria
library(openxlsx)  # Librería moderna y eficiente para trabajar con archivos Excel
library(readxl)      # Para leer archivos .xlsx

#  Definir ubicación de trabajo y nombre de archivo
setwd("/tmp/SDIS_SIRBE")  # Establece la carpeta donde están los archivos

# Leer archivo Excel
archivo <- "database/CargueSIRBEVejez.xlsx"
if (!file.exists(archivo)) stop("El archivo Excel no se encuentra en la ruta especificada.")

archivo_salida <- "tablas/FrecuenciaPorVivienda.xlsx"  # Archivo de salida

# Leer hoja por defecto (primera hoja)
base_sdis <- read_excel(archivo)

# Validar que las columnas necesarias estén presentes
if (!all(c("NOMTENVIV", "EDAD_ACTUAL") %in% colnames(base_sdis))) {
  stop(" Las columnas 'NOMTENVIV' y/o 'EDAD_ACTUAL' no existen en los datos.")
}

# Construcción de tabla de frecuencia cruzada
# Muestra la cantidad de personas por tipo de vivienda y edad actual
Frecuencia <- table(base_sdis$NOMTENVIV, base_sdis$EDAD_ACTUAL)

# Cálculo de totales y porcentajes
SumaFrecuencia <- rowSums(Frecuencia)  # Total por tipo de vivienda
TotalFrecuencia <- sum(SumaFrecuencia)  # Total general
PorcentajeFrecuencia <- round(prop.table(SumaFrecuencia) * 100, 2)  # Porcentaje por fila

# Construcción de nueva tabla resumen
tablaFrecuencia <- data.frame(
  Tipo_Vivienda = names(SumaFrecuencia),  # Nombre de la categoría
  Total = SumaFrecuencia,                 # Total de casos por categoría
  Porcentaje = PorcentajeFrecuencia       # Porcentaje del total general
)

# Crear carpeta de salida si no existe
if (!dir.exists("tablas")) {
  dir.create("tablas")  # Crea la carpeta 'tablas' si aún no existe
}

# Exportar tabla resumen a archivo Excel (.xlsx)
write.xlsx(tablaFrecuencia, file = archivo_salida, sheetName = "Frecuencia", rowNames = FALSE)

# Agregar segunda hoja al mismo archivo Excel con la tabla cruzada completa
addWorksheetBook <- loadWorkbook(archivo_salida)  # Cargar el archivo previamente creado
addWorksheet(addWorksheetBook, "Tabla_Cruzada")   # Crear nueva hoja
writeData(addWorksheetBook, sheet = "Tabla_Cruzada", x = as.data.frame.matrix(Frecuencia))
saveWorkbook(addWorksheetBook, file = archivo_salida, overwrite = TRUE)  # Guardar cambios

# Crear gráfico de barras de los totales y guardarlo como imagen PNG
png("tablas/FrecuenciaPorVivienda.png", width = 900, height = 600)
barplot(SumaFrecuencia,
        las = 2,                        # Rotación de etiquetas
        col = "skyblue",               # Color de barras
        main = "Frecuencia por Tipo de Vivienda",
        ylab = "Total",
        cex.names = 0.8)               # Tamaño de etiquetas
dev.off()  # Finaliza y guarda el gráfico

# Mensaje de finalización
cat("Análisis finalizado. Archivo guardado en:", archivo_salida, "\n")
