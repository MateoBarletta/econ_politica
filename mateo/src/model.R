library(tidyverse)
library(janitor)
library(here)
library(haven)
library(sandwich)
library(lmtest)

# Carga codiguera ISO
iso <- readRDS("mateo/data/internas/iso.rds")

# Carga Base Latinobarometro 2017
latin_2017 <- readRDS("mateo/data/internas/latin_2017.rds") %>% 
sjlabelled::remove_all_labels() 

# Carga Base Latinobarometro 2015
latin_2015 <- readRDS("mateo/data/internas/latin_2015.rds")  %>% 
  sjlabelled::remove_all_labels() 

# Carga Base Latinobarometro 2009
latin_2009 <- readRDS("mateo/data/internas/latin_2009.rds")  %>% 
  sjlabelled::remove_all_labels() 

# Carga WVS
df_wvs <- read_dta("mateo/data/externas/WVS_dataset.dta") %>% 
  sjlabelled::remove_all_labels() %>% 
  mutate(sex         = as.factor(sex),
         regioncode  = as.factor(regioncode),
         continent   = as.factor(continent),
         countrycode = as.factor(countrycode), 
         married     = as.factor(married),
         primary     = as.factor(primary),
         secondary   = as.factor(secondary))

# Carga cross country dataset
cross_country <- read_dta("mateo/data/externas/crosscountry_dataset.dta") %>% 
  sjlabelled::remove_all_labels()

# Genero df auxiliares para joinear al latinobarometro
# A nivel pais
control_pais <- cross_country %>% 
  filter(continent== 'South America') %>% 
  transmute(iso3 = as.character(isocode), plow, agricultural_suitability, tropical_climate, 
            large_animals, political_hierarchies, economic_complexity, ln_income, ln_income_squared) %>% 
  left_join(iso, by='iso3') %>% 
  mutate(countrycode = as.factor(countrycode))

# A nivel region
aux <- df_wvs %>% 
  filter(continent== 'South America') %>% 
  transmute(region = as.character(regioncode),
            plow, tropical_climate, economic_complexity, political_hierarchies, 
            agricultural_suitability, large_animals, ln_income, ln_income2) %>% 
  distinct() %>% 
  mutate(region = case_when(nchar(region)==5 ~ str_c('0', region), T ~ region),
         region = as.factor(region))

aux1 <- latin_2009 %>% 
  transmute(countrycode     = as.character(idenpa),
            region          = as.character(reg)) %>% 
  distinct() %>% 
  mutate(region = case_when(nchar(region)==5 ~ str_c('0', region), T ~ region),
         region = as.factor(region),
         countrycode = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode), T ~ countrycode),
         countrycode = as.factor(countrycode)) %>% 
  left_join(aux, by='region') 

aux2 <- aux1 %>% 
  filter(is.na(plow)==T) %>% 
  select(region, countrycode) %>% 
  left_join(control_pais, by='countrycode') %>% 
  select(-iso3, -pais)

control_region <-  aux1 %>% 
  filter(is.na(plow)==F) %>% 
  bind_rows(aux2) %>% 
  mutate(region = as.factor(region)) %>% 
  arrange(region) %>% 
  rowwise() %>% 
  mutate(ln_income_squared = ln_income*ln_income) %>% 
  select(-countrycode, -ln_income2)

rm(aux, aux1, aux2)

# Joinea Latinobarometro 2017 con base del paper a nivel pais
df_latin_2017_pais <- latin_2017 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud), 
            educ1           = REEDUC.1,
            educ2           = REEDUC.2,
            preg_parlamento = as.double(P53N.F),
            preg_jueces     = as.double(P53N.G),
            wt, edad, sexo) %>% 
  mutate(countrycode = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode), T ~ countrycode),
         countrycode = as.factor(countrycode),
         preg_parlamento = case_when(preg_parlamento == -1 ~ NA_real_, TRUE ~ preg_parlamento),
         preg_jueces     = case_when(preg_jueces == -1 ~ NA_real_, TRUE ~ preg_jueces)) %>% 
  left_join(control_pais, by='countrycode') 

# Joinea Latinobarometro 2017 con base del paper a nivel region
df_latin_2017_region <- latin_2017 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud), 
            educ1           = REEDUC.1,
            educ2           = REEDUC.2,
            preg_parlamento = as.double(P53N.F),
            preg_jueces     = as.double(P53N.G),
            wt, edad, sexo) %>% 
  mutate(region          = as.character(region),
         region          = case_when(nchar(region)==5 ~ str_c('0', region), T ~ region),
         region          = as.factor(region),
         preg_parlamento = case_when(preg_parlamento == -1 ~ NA_real_, TRUE ~ preg_parlamento),
         preg_jueces     = case_when(preg_jueces == -1 ~ NA_real_, TRUE ~ preg_jueces)) %>% 
  left_join(control_region, by = 'region')


# Joinea Latinobarometro 2015 con base del paper a nivel pais
df_latin_2015_pais <- latin_2015 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud), 
            edad            = reedad,
            educ1           = REEDUC_1,
            educ2           = REEDUC_2,
            preg_trabajar   = as.double(P69ST.A),
            wt) %>% 
  mutate(countrycode     = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode), T ~ countrycode),
         preg_trabajar = case_when(preg_trabajar == -1 ~ NA_real_, TRUE ~ preg_trabajar)) %>% 
  left_join(control_pais, by='countrycode') %>% 
  mutate(countrycode = as.factor(countrycode))

# Joinea Latinobarometro 2015 con base del paper a nivel region
df_latin_2015_region <- latin_2015 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud), 
            edad            = reedad,
            educ1           = REEDUC_1,
            educ2           = REEDUC_2,
            preg_trabajar   = as.double(P69ST.A),
            wt) %>% 
  mutate(region          = as.character(region),
         region          = case_when(nchar(region)==5 ~ str_c('0', region), T ~ region),
         region          = as.factor(region),
         preg_trabajar = case_when(preg_trabajar == -1 ~ NA_real_, TRUE ~ preg_trabajar)) %>% 
  left_join(control_region, by = 'region')


# Joinea Latinobarometro 2009 con base del paper a nivel pais
df_latin_2009_pais <- latin_2009 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud),
            educ1           = reeduc1,
            educ2           = reeduc2,
            educ3           = reeduc3,
            mujer_hogar     = p67st_c,
            mujer_politica  = p67wvs_d,
            wt, reedad) %>% 
  mutate(countrycode = as.character(countrycode),
         countrycode    = case_when(nchar(countrycode)==2 ~ str_c('0', countrycode), T ~ countrycode),
         mujer_politica = case_when(mujer_politica == -2 ~ NA_real_, TRUE ~ mujer_politica),
         mujer_hogar    = case_when(mujer_hogar == -2 ~ NA_real_, TRUE ~ mujer_hogar)) %>% 
  left_join(control_pais, by='countrycode') %>% 
  mutate(countrycode = as.factor(countrycode)) 

# Joinea Latinobarometro 2009 con base del paper a nivel region
df_latin_2009_region <- latin_2009 %>% 
  transmute(countrycode     = as.character(idenpa), 
            region          = as.factor(reg),
            ciudad          = as.factor(ciudad), 
            tamciud         = as.factor(tamciud),
            educ1           = reeduc1,
            educ2           = reeduc2,
            educ3           = reeduc3,
            mujer_hogar     = p67st_c,
            mujer_politica  = p67wvs_d,
            wt, reedad) %>% 
  mutate(region         = as.character(region),
         region         = case_when(nchar(region)==5 ~ str_c('0', region), T ~ region),
         region         = as.factor(region),
         mujer_politica = case_when(mujer_politica == -2 ~ NA_real_, TRUE ~ mujer_politica),
         mujer_hogar    = case_when(mujer_hogar == -2 ~ NA_real_, TRUE ~ mujer_hogar)) %>% 
  left_join(control_region, by='region')

write_dta(df_latin_2017_pais, "mateo/data/internas/df_latin_2017_pais.dta")
write_dta(df_latin_2017_region, "mateo/data/internas/df_latin_2017_region.dta")
write_dta(df_latin_2015_pais, "mateo/data/internas/df_latin_2015_pais.dta")
write_dta(df_latin_2015_region, "mateo/data/internas/df_latin_2015_region.dta")
write_dta(df_latin_2009_pais, "mateo/data/internas/df_latin_2009_pais.dta")
write_dta(df_latin_2009_region, "mateo/data/internas/df_latin_2009_region.dta")

rm(latin_2009, latin_2015, latin_2017)
