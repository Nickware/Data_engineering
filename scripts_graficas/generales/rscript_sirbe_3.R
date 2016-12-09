library(extrafont)
setwd("/tmp/SDIS_SIRBE/database/")
base_sdis <- read.csv("CargueSIRBEVejez.csv",header = T)
Frecuencia <- table(base_sdis$NOMACTUACION, base_sdis$EDAD_ACTUAL)
#Nombre de columnas
colnames(Frecuencia)
#Nombres filas
rownames(Frecuencia)
#Sumar los valores numericos de la filas
SumaFrecuencia<-rowSums(Frecuencia)
#Sumar todos los valores numericos de la variable
TotalFrecuencia <- sum(SumaFrecuencia)
#Calcula el porcentaje
PorcentajeFrecuencia <- (prop.table(SumaFrecuencia))
#Unir columnas y contruir una nueva tabla
tablaFrecuencia <- cbind(SumaFrecuencia, PorcentajeFrecuencia)
#Renombrasr columnas
colnames(tablaFrecuencia) <- c("Total", "Porcentaje")
#df <- data.frame(tablaFrecuencia)
x <- tablaFrecuencia[, "Porcentaje"]
#datos <- data.frame(x)
#Función para par formato al porcentaje
percent <- function(x, digits = 2, format = "f") 
{
  paste0(formatC(100 * x, format = format, digits = digits), "%")
}
#Para imprimir en png
png(filename = "/tmp/graficas/grafica.png",
    #Modificar las dimensiones 
    #widht 1480 1280 680 480
    width = 680, height = 480, units = "px", pointsize = 12,
    bg = "white",  res = NA, 
    type = c("cairo", "cairo-png", "Xlib", "quartz"))
#Crear gráfica, estilo=barra 
bp <-barplot(x, main="Distribución de población del beneficiario por modalidad de atención", axes=FALSE,
        col=c("steelblue"), ylim=c(0,1),
        legend = rownames(x), beside=TRUE)
        #Modificar tamaño los nombres del texto en la leyenda
        #Para casos dimensiones 1480 1280
        #cex.axis=1.5, cex.names=1)
#Coloca el porcentaje en la parte inferior de la barra
text(bp, 0, percent(x),cex=1, pos=3, col="black")
#Funcion que da por terminada la impresion de grafica en el formato predefinido 
dev.off()
