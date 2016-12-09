#Librerias 
library(xlsx)
library(openxlsx)
library(extrafont)
#Definir ubicación
setwd("/tmp/SDIS_SIRBE")
#Cargar base de datos
base_sdis <- read.csv("database/CargueSIRBEVejez.csv",header = T)
#Construir una tabla con dos variables
Frecuencia <- table(base_sdis$NOMTENVIV, base_sdis$EDAD_ACTUAL)
#Hacer filtros de rangos
Otros <- Frecuencia[, 1:9]
Temprana <- Frecuencia[, 10:18]
#Nombre de columnas
colnames(Otros)
colnames(Temprana)
#Nombres filas
rownames(Temprana)
Tardia <- Frecuencia[, 19:57]
colnames(Tardia)
rownames(Tardia)
Tardia
Temprana
Otros
#Sumar los valores numericos de la filas
SumaOtros<-rowSums(Otros)
SumaTemprana<-rowSums(Temprana)
SumaTardia<-rowSums(Tardia)
#Sumar todos los valores numericos de la variable
TotalOtros <- sum(SumaOtros)
TotalTemprana <- sum(SumaTemprana)
TotalTardia <- sum(SumaTardia)
#Calcula el porcentaje
PorcentajeOtros <- (prop.table(SumaOtros))
PorcentajeTemprana <- (prop.table(SumaTemprana))
PorcentajeTardia <- (prop.table(SumaTardia))
PorcentajeTTotal <- (prop.table(SumaTardia))
#Unir columnas y contruir una nueva tabla
tablaTemprana <- cbind(SumaTemprana, PorcentajeTemprana)
#Renombrasr columnas
colnames(tablaTemprana ) <- c("Total", "%")
tablaTardia <- cbind(SumaTardia, PorcentajeTardia)
colnames(tablaTardia) <- c("Total", "%")
tablaOtros <- cbind(SumaOtros, PorcentajeOtros)
colnames(tablaOtros) <- c("Total", "%")
#Guardar en una tabla nueva
TempranaPrint <- as.table(tablaTemprana)
TardiaPrint <- as.table(tablaTardia)
OtrosPrint <- as.table(tablaOtros)
#Crear lista de imprimibles
lista_de_datos <- list("Otros" = OtrosPrint, "Vejez Temprana" = TempranaPrint, "Vejez Tardia" = TardiaPrint)
#Imprime a un archivo de formato xlsx
write.xlsx(lista_de_datos, file = "tablas/tabla.xlsx")