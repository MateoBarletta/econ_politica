library(tidyverse)
library(janitor)
library(here)
library(haven)

# Carga codiguera ISO
iso <- readRDS("data/internas/iso.rds")

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
  select(iso3, flfp2000, female_ownership, women_politics, plow, agricultural_suitability, tropical_climate, 
         large_animals, political_hierarchies, economic_complexity, ln_income, ln_income_squared) %>% 
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
