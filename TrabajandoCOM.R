# Se usa libreria rvest
library(rvest)

#-------pagina utilizada: trabajando.com-----------#
#se incorpora link respectivo, filtrando Región Metropolitana e Ingenieros Comerciales
trabajando <- "https://www.trabajando.cl/ofertas-trabajo-empleo/region-Metropolitana-ingeniero-comercial/QHwj5UQh5B4NM8B0AAUB_0OsbZ5XU6jaaRgHM-b1Rm48SSxEXbBiZ8vxhLFDRKeEK4Eau9Q7lI_x5T7-tic2HCtoKSDGi278VExn4evVjhBUaW7_HUCBW2hKNQnbcknF"

# Leyendo HTML del archivo a utilizar
leer <- read_html(trabajando)

#Se extrae la informacion de una clase de la pagina
contenido<-html_node(leer,'.pagination1')
print(contenido)

cont2<-html_nodes(contenido,'a')
print(cont2)

Links<-html_attr(cont2,'href')
print(Links)

# Se Crea data.frame 
webpage <- data.frame()

for(i in 1:23){
  #Se realiza la busqueda y se asigana URL a la respectiva variable
  paginatrabajando <- paste("https://www.trabajando.cl/ofertas-trabajo-empleo/region-Metropolitana-de-Santiago-ingeniero-comercial/TYLxufBdCY28pyGQmc6yeYcdfzBHgHQn_EOA9sZh5JCLcccmY5DtRs9xemqpsWYp3FxrmcOZl4yGxZjtaLjmZMhQ_0TD1y_6GszjdYxxqG8mV-4CzSiVOVyrmdctnlEOJdNbaNAgZ7Q7Dmu7Zd6yF1LqpcDzP08oQZOnXTHi2gw/",i,sep = "")
  print(paginatrabajando)
  lapagina <-read_html(paginatrabajando)
  
#Se utiliza la clase del div que contiene la informacion del cargo publicado, para extraer la informacion que se necesita
  contenidotrabajando <- html_nodes(lapagina,'.md2_lista_oferta_content')
#Se utiliza tag a  
  contenidoTrabajanding <- html_nodes(contenidotrabajando,'a')
#Se extraen los link  
  links<-html_attr(contenidoTrabajanding,"href")
  
  #-----------Extraccion de datos link x link------------------#
  for(link in links){
    print(link)
    Datosimportantes<- link
    
    datitos <-read_html(Datosimportantes)

# Se extraen los nombres de las empresas que han publicado ofertas de empleo en el ultimo periodo, a traves de su clase respectiva
    
    empresa <- html_nodes(datitos, "[itemprop=hiringOrganization]")
    empresa <- html_text(empresa)
    
    {
    df <- data.frame(empresa = empresa)
      webpage <- rbind(webpage,df)
    }
    
# Se une la información extraida
    webpage <- rbind(webpage,df) 
  }
}

{
  #Se instala ggplot2 para graficar
  library('ggplot2')
  
  #Grafico de barra ejecutado
  webpage %>%
    ggplot() +
    aes(x = empresa, y = "") +
    geom_bar(stat="identity")
}
  
{
  #Se usa gsub para limpiar la data y eliminar \n y \t    
  webpage$empresa <- gsub("\t","",webpage$empresa)  
  webpage$empresa <- gsub("\n","",webpage$empresa) 
}

# Almacenaciento de archivo en csv  
write.csv(webpage, file = 'ArchivoEmpresasIC.csv')
