library(tidyverse)
library(janitor)

# Carga Base 2017
latin_2017 <- readRDS("C:/Users/Usuario/Desktop/Latinobarometro/proyecto/data/internas/latin_2017.rds")

# Tabla Idioma
tabyl(latin_2017$S24.A)

# Tabla Religion
tabyl(latin_2017$S9)

# Tabla Raza
tabyl(latin_2017$S10)


# Que la mitad de los miembros del parlamento tengan que ser mujeres
tabla1 <- latin_2017 %>%  
  group_by(P53N.F) %>% 
  summarise(casos = n())

# Que la mitad de los jueces tengan que ser mujer
tabla2 <- latin_2017 %>%  
  group_by(P53N.G) %>% 
  summarise(casos = n())

# Cual de los siguientes tipos de violencia cree ud que es mas dañina para el desarrollo de un pais
tabla3 <- latin_2017 %>% 
  group_by(P64STAA) %>% 
  summarise(casos = n())

# Cual de los siguientes tipos de violencia cree ud que es mas dañina para el desarrollo de un pais
tabla4 <- latin_2017 %>% 
  group_by(P64STAB) %>% 
  summarise(casos = n())