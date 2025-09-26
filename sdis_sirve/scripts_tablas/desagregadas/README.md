## Procesamiento y Gráficas: Vejez por Tipo de Vivienda (SIRBE - SDIS)

### Descripción

Este script en R permite procesar datos de personas mayores segmentados por tipo de vivienda, a partir de un archivo Excel de SIRBE - SDIS. Genera tablas y gráficos para tres grupos etarios: otros (<60 años), vejez temprana (60-74 años) y vejez tardía (75+ años). Los resultados se exportan en formato Excel y como archivos PNG, todo en la carpeta `tablas`.

***

### Requisitos

- R (>= 4.0)
- Paquetes: `dplyr`, `readxl`, `openxlsx`, `ggplot2`
- Archivo de entrada: `database/CargueSIRBEVejez.xlsx` con las columnas `NOMTENVIV` (tipo de vivienda) y `EDAD_ACTUAL` (edad en años)

***

### Uso

1. Colocar el archivo Excel original en `database/CargueSIRBEVejez.xlsx`.
2. Definir el directorio de trabajo en la línea correspondiente (`setwd("/tmp/SDIS_SIRBE")`).
3. Ejecutar el script en R.
4. El script procesa los datos, genera tablas y gráficos por grupo etario, y guarda los resultados en la carpeta `tablas`.

***

### Salidas

- **Excel:** `tablas/resumen_vejez_con_graficos.xlsx` con una hoja por grupo etario, mostrando la tabla de frecuencia y el gráfico correspondiente.
- **Imágenes PNG:** Gráficos de barras por grupo etario en la carpeta `tablas`.
