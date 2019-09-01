library(tidyverse)
library(janitor)
library(here)
library(haven)
library(sandwich)
library(lmtest)

# Carga codiguera ISO
iso <- readRDS("data/internas/iso.rds")

# Carga Base Latinobarometro 2017
latin_2017 <- readRDS("data/internas/latin_2017.rds") 

# Carga Base Latinobarometro 2009
latin_2009 <- readRDS("data/internas/latin_2009.rds") 

# Carga WVS
df_wvs <- read_dta("data/externas/WVS_dataset.dta") %>% 
  mutate(sex         = as.factor(sex),
         regioncode  = as.factor(regioncode),
         continent   = as.factor(continent),
         countrycode = as.factor(countrycode), 
         married     = as.factor(married),
         primary     = as.factor(primary),
         secondary   = as.factor(secondary))

# Carga cross country dataset
cross_country <- read_dta("data/externas/crosscountry_dataset.dta")

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
            tamciud         = as.factor(tamciudad), 
            wt, edad, sexo,
            educ1           = REEDUC.1,
            educ2           = REEDUC.2,
            preg_parlamento = P53N.F,
            preg_jueces     = P53N.G,
            dif_conflicto   = P21ST.F) %>% 
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
            wt, reedad, sexo,
            educ1           = reeduc1,
            educ2           = reeduc2,
            educ3           = reeduc3,
            preg_hogar      = p67st_c,
            preg_politicos  = p67wvs_d) %>% 
  mutate(countrycode = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode),
                                 T ~ countrycode)) %>% 
  left_join(aux2, by='countrycode') %>% 
  mutate(countrycode = as.factor(countrycode))

# Modelos Paper 
# Tabla 3
col1 <- lm(flfp2000 ~ plow + agricultural_suitability + large_animals + tropical_climate + political_hierarchies + economic_complexity +ln_income + ln_income_squared, data = cross_country)

# Tabla 4
colu2 <- lm(jobs_scarce ~ plow + ln_income + ln_income2 + economic_complexity + large_animals + political_hierarchies + tropical_climate + agricultural_suitability + primary + secondary  + age + age_sq + married + sex + continent, data = df_wvs)

# Regresion con los datos del latinobarometro, prueb


rm(aux, aux2, col1, colu2)
