library(extrafont)
setwd("/tmp/SDIS_SIRBE/database/")
base_sdis <- read.csv("CargueSIRBEVejez.csv",header = T)
Frecuencia <- table(base_sdis$NOMTENVIV, base_sdis$EDAD_ACTUAL)
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
#Para imprimir en pdf
pdf(file = "/tmp/grafica.pdf", width = 12, height = 7, family = "Helvetica")
#Crear gráfica, estilo=barra 
bp <- barplot(x, main="Distribución Beneficiaria Tenencia de la Vivienda", axes=FALSE,
        col=c("steelblue"), ylim=c(0,0.9),
        legend = rownames(x), beside=TRUE)
#Coloca el porcentaje en la parte inferior de la barra
text(bp, 0, percent(x),cex=2, pos=3, col="black")
#Funcion que da por terminada la impresion de grafica en el formato predefinido 
dev.off()
