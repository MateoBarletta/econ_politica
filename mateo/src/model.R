library(tidyverse)
library(janitor)
library(here)
library(haven)
library(sandwich)
library(lmtest)

# Carga codiguera ISO
iso <- readRDS("mateo/data/internas/iso.rds")

# Carga Base Latinobarometro 2017
latin_2017 <- readRDS("mateo/data/internas/latin_2017.rds") 

# Carga Base Latinobarometro 2015
latin_2015 <- readRDS("mateo/data/internas/latin_2015.rds") 

# Carga Base Latinobarometro 2009
latin_2009 <- readRDS("mateo/data/internas/latin_2009.rds") 

# Carga WVS
df_wvs <- read_dta("mateo/data/externas/WVS_dataset.dta") %>% 
  mutate(sex         = as.factor(sex),
         regioncode  = as.factor(regioncode),
         continent   = as.factor(continent),
         countrycode = as.factor(countrycode), 
         married     = as.factor(married),
         primary     = as.factor(primary),
         secondary   = as.factor(secondary))

# Carga cross country dataset
cross_country <- read_dta("mateo/data/externas/crosscountry_dataset.dta")

# Genero df auxiliares para joinear al latinobarometro
aux <- df_wvs %>% 
  filter(continent== 'South America') %>% 
  transmute(countrycode = as.character(countrycode),
            plow, tropical_climate, economic_complexity, political_hierarchies, 
            agricultural_suitability, large_animals, ln_income, ln_income2) %>% 
  distinct()

aux2 <- cross_country %>% 
  filter(continent== 'South America') %>% 
  transmute(iso3 = as.character(isocode), 
            flfp2000, female_ownership, women_politics, plow, agricultural_suitability, tropical_climate, 
            large_animals, political_hierarchies, economic_complexity, ln_income, ln_income_squared) %>% 
  left_join(iso, by='iso3')

# Joinea Latinobarometro 2017 con base del paper a nivel pais
df_latin_2017 <- latin_2017 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud), 
            educ1           = REEDUC.1,
            educ2           = REEDUC.2,
            preg_parlamento = P53N.F,
            preg_jueces     = P53N.G,
            dif_conflicto   = P21ST.F,
            wt, edad, sexo) %>% 
  mutate(countrycode = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode),
                                 T ~ countrycode)) %>% 
  left_join(aux2, by='countrycode') %>% 
  mutate(countrycode = as.factor(countrycode))

# Joinea Latinobarometro 2015 con base del paper a nivel pais
df_latin_2015 <- latin_2015 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud), 
            edad            = reedad,
            educ1           = REEDUC_1,
            educ2           = REEDUC_2,
            preg_trabajar   = P69ST.A,
            wt) %>% 
  mutate(countrycode = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode),
                                 T ~ countrycode)) %>% 
  left_join(aux2, by='countrycode') %>% 
  mutate(countrycode = as.factor(countrycode))

# Joinea Latinobarometro 2009 con base del paper a nivel pais
df_latin_2009 <- latin_2009 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud),
            educ1           = reeduc1,
            educ2           = reeduc2,
            educ3           = reeduc3,
            preg_hogar      = p67st_c,
            preg_politicos  = p67wvs_d,
            wt, reedad) %>% 
  mutate(countrycode = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode),
                                 T ~ countrycode)) %>% 
  left_join(aux2, by='countrycode') %>% 
  mutate(countrycode = as.factor(countrycode))

rm(aux, aux2, col1, colu2, latin_2009, latin_2015, latin_2017)
