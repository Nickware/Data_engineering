# LIBRERÍAS ----
library(ggplot2)
library(scales)  # Para formato de porcentajes
library(dplyr)   # Para manipulación de datos

# CONFIGURACIÓN INICIAL ----
# Establecer directorio de trabajo con verificación
if(dir.exists("/tmp/SDIS_SIRBE/database/")) {
  setwd("/tmp/SDIS_SIRBE/database/")
} else {
  stop("El directorio especificado no existe")
}

# CARGA DE DATOS ----
# Cargar datos con manejo de errores y especificación de encoding
if(file.exists("CargueSIRBEVejez.csv")) {
  base_sdis <- read.csv("CargueSIRBEVejez.csv", 
                       header = TRUE, 
                       stringsAsFactors = FALSE,
                       fileEncoding = "UTF-8")
  
  # Verificar que las columnas necesarias existan
  if(!all(c("EDAD_ACTUAL", "NOMSEXO") %in% colnames(base_sdis))) {
    stop("El dataset no contiene las columnas requeridas (EDAD_ACTUAL, NOMSEXO)")
  }
} else {
  stop("El archivo CargueSIRBEVejez.csv no existe en el directorio especificado")
}

# PREPARACIÓN DE DATOS ----
# Crear tabla de frecuencias con porcentajes
datos_grafico <- base_sdis %>%
  count(NOMSEXO, name = "Frecuencia") %>%
  mutate(Porcentaje = Frecuencia/sum(Frecuencia),
         Etiqueta = percent(Porcentaje, accuracy = 0.1))  # Usando scales::percent

# VISUALIZACIÓN ----
grafico <- ggplot(datos_grafico, aes(x = reorder(NOMSEXO, -Porcentaje), y = Porcentaje)) +
  geom_col(fill = "#1E88E5", width = 0.7, alpha = 0.8) +  # Azul moderno
  geom_text(aes(label = Etiqueta), 
            vjust = -0.5, 
            color = "black", 
            size = 3.5) +
  scale_y_continuous(labels = percent_format(), 
                    limits = c(0, max(datos_grafico$Porcentaje) * 1.1)) +
  labs(title = "Distribución de beneficiarios por sexo",
       subtitle = "Análisis poblacional del sistema SIRBE",
       x = NULL,
       y = "Porcentaje") +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 12),
    plot.subtitle = element_text(hjust = 0.5, size = 10),
    axis.text = element_text(size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  )

# EXPORTACIÓN DEL GRÁFICO ----
# Tamaño en píxeles (480px = ~5.33in a 90ppi)
ggsave("/tmp/grafica.png", 
       plot = grafico,
       width = 5.33, 
       height = 4, 
       units = "in",
       dpi = 90)  # Resolución estándar para web

# Mensaje de confirmación
message("Gráfico generado y guardado exitosamente en /tmp/grafica.png")
