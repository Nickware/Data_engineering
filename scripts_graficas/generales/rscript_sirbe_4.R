#LIbreria para especializada para gráficas de alta calidad en R
library(ggplot2)
setwd("/tmp/SDIS_SIRBE/database/")
base_sdis <- read.csv("CargueSIRBEVejez.csv",header = T)
#Mis variables
edad=base_sdis$EDAD_ACTUAL
sexo=base_sdis$NOMSEXO
#Creo una tabla para una variable
x <- table(sexo)
#Calcula el porcentaje
porcentaje <-prop.table(x)
#Creouna tabla para los valores porcentuados
ul <- data.frame(porcentaje)
#Función para aplicar el formato de porcentaje en digitos
percent <- function(x, digits = 2, format = "f") 
{
  paste0(formatC(100 * x, format = format, digits = digits), "%")
}
#Aplicar la funcion percent a la columna Freq del frame de datos ul 
etiqueta<-percent(ul$Freq)
#Bloque para producir gráfica
ggplot(data=ul, aes(x=sexo, y=Freq)) +
  ggtitle("Distribución poblacional del beneficiario por sexo")+
  ylim(0, 1)+
  theme(plot.title = element_text(size=3, face="bold"),
        axis.title.x=element_blank(),
        axis.text.x=element_text(size =3),
        axis.title.y=element_blank(),
        axis.text.y=element_text(size = 3),
        panel.background = element_blank())+
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=etiqueta), 
            vjust=-0.1, 
            color="black", 
            size=1)
#Para guardar gráfica
#Modificar las dimensiones widht en pulgadas in
#Utilizar conversor de unidades gráficas de Gimp
#1480 px == 4.933
#1280 px == 4.267 in
#680 px == 2.267 in
#480 px == 1.6 in
ggsave("/tmp/grafica.png", width = 1.6, height = 1.6, units = "in")
  #theme_minimal()