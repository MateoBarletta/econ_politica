library(tidyverse)
library(janitor)
library(here)
library(haven)

# Carga codiguera ISO
iso <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv") %>% 
  transmute(pais         = name,
            iso3         = `alpha-3`,
            countrycode = `country-code`)

# Carga Base Latinobarometro 2017
latin_2017 <- readRDS("data/internas/latin_2017.rds") 

# Carga WVS
df_wvs <- read_dta("data/externas/WVS_dataset.dta") 

aux <- df_wvs %>% 
  filter(continent== 'South America') %>% 
  transmute(countrycode = as.character(countrycode),
            plow, tropical_climate, economic_complexity, political_hierarchies, 
            agricultural_suitability, large_animals, ln_income, ln_income2) %>% 
  distinct()

# Carga cross country dataset
cross_country <- read_dta("data/externas/crosscountry_dataset.dta") %>% 
  rename(iso3 = `isocode`)

aux2 <- cross_country %>% 
  filter(continent== 'South America') %>% 
  left_join(iso, by='iso3')

# Joinea Latinobarometro con base del paper a nivel pais
df_latin <- latin_2017 %>% 
  transmute( countrycode    = as.character(idenpa), 
             region          = as.character(reg),
             ciudad, tamciud, wt, edad, sexo,
             educ1           = REEDUC.1,
             educ2           = REEDUC.2,
             preg_parlamento = P53N.F,
             preg_jueces     = P53N.G,
             dif_conflicto   = P21ST.F) %>% 
  left_join(aux2, by='countrycode')








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