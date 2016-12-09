#Librerias 
library(xlsx)
library(openxlsx)
library(extrafont)
#Definir ubicación
setwd("/tmp/SDIS_SIRBE")
#Cargar base de datos
base_sdis <- read.csv("CargueSIRBEVejez.csv",header = T)
#Construir una tabla con dos variables
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
colnames(tablaFrecuencia) <- c("Total", "%")
#Guardar en una tabla nueva
FrecuenciaPrint <- as.table(tablaFrecuencia)
#Crear lista de imprimibles
lista_de_datos <- list("Generales" = FrecuenciaPrint)
#Imprime a un archivo de formato xlsx
write.xlsx(lista_de_datos, file = "tablas/generales.xlsx")