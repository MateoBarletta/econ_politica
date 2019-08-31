library(tidyverse)
library(janitor)
library(here)

# Carga Base 2017
latin_2017 <- readRDS("data/internas/latin_2017.rds") 

df_latin <- latin_2017 %>% 
  transmute( pais            = idenpa, 
             region          = reg,
             ciudad, tamciud, wt, edad, sexo,
             educ1           = REEDUC.1,
             educ2           = REEDUC.2,
             preg_parlamento = P53N.F,
             preg_jueces     = P53N.G,
             dif_conflicto   = P21ST.F)


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