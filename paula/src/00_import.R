# devtools::install_github("EL-BID/Libreria-R-Numeros-para-el-Desarrollo", force = TRUE)
# devtools::install_github("EL-BID/Agregador-de-indicadores", force = TRUE)
library(tidyverse)
library(agregadorindicadores)

iso <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv") %>% 
  select(iso2 = `alpha-2`,
         iso3 = `alpha-3`,
         country_code = `country-code`)

clean_structure_wdi <- function(df) {
  df %>% 
    spread(indicator, value) %>% 
    select(- src_id_ind, 
           - src_id_dataset,
           - dataset,                                                  
           - uom,                                                       
           - topic,                                                     
           - api,                                                       
           - gender,                                                    
           - multiplier,                                             
           - area,
           - year,
           - ind_description,
           - source,
           - country) %>% 
    janitor::clean_names()
}

# Keywords BM para sacar dtaos

keywords <- ind_search(pattern = "female")

### Variables que puede estar bueno usar:

variables <- c("SL.TLF.TOTL.FE.ZS", # Labor Force Participation Rate (%), Female
               "SL.AGR.EMPL.FE.ZS", # Employment in agriculture, female (% of female employment)
               "SP.DYN.TFRT.IN", # Fertility rate, total (births per woman)
               "SH.STA.MMRT", # Maternal mortality ratio (modeled estimate, per 100,000 live births)
               "PRJ.MYS.25UP.GPI", # Projection: Mean Years of Schooling. Age 25+. Gender Gap
               "SE.ENR.TERT.FM.ZS", # School enrollment, tertiary (gross), gender parity index (GPI)
               "SE.ENR.SECO.FM.ZS", # School enrollment, secondary (gross), gender parity index (GPI)
               "SE.ENR.PRSC.FM.ZS", # School enrollment, primary and secondary (gross), gender parity index (GPI)
               "SE.ENR.PRIM.FM.ZS") # School enrollment, primary (gross), gender parity index (GPI)

paises_paper <- haven::read_dta("plough_replication/crosscountry_dataset.dta") %>% 
  rename(iso3 = isocode) %>% 
  left_join(iso) %>% 
  distinct(iso2) %>% 
  pull()

labor_force <- ai(indicator = "SL.TLF.TOTL.FE.ZS", country = paises_paper, startdate = 2014, enddate = 2014) %>% 
  clean_structure_wdi()

employment_agriculture <- ai(indicator = "SL.AGR.EMPL.FE.ZS", country = paises_paper, startdate = 2014, enddate = 2014) %>% 
  clean_structure_wdi()

fertility <- ai(indicator = "SP.DYN.TFRT.IN", country = paises_paper, startdate = 2014, enddate = 2014) %>% 
  clean_structure_wdi()

maternal_mortality <- ai(indicator = "SH.STA.MMRT", country = paises_paper, startdate = 2014, enddate = 2014) %>% 
  clean_structure_wdi()

schooling <- ai(indicator = "PRJ.MYS.25UP.GPI", country = paises_paper, startdate = 2014, enddate = 2014) %>% 
  clean_structure_wdi()

df_wdi <- labor_force %>% 
  left_join(employment_agriculture, by = "iso2") %>% 
  left_join(fertility, by = "iso2") %>% 
  left_join(maternal_mortality, by = "iso2") %>% 
  left_join(schooling, by = "iso2") %>% 
  readr::write_rds('paula/data/df_wdi.rds') 

df_wvs <- haven::read_dta("paula/data/WV6_Data_Stata_v20180912.dta") %>% 
  transmute(country_code = V2,
            jobs_scarse = V45,
            women_earns_more = V47,
            women_job_children = V50,
            men_better_leaders = V51,
            boy_girl_university = V52,
            men_better_executive = V53) %>% 
  sjlabelled::remove_all_labels() %>% 
  mutate(country_code = as.character(country_code)) %>% 
  mutate(country_code = case_when(
    nchar(country_code) == 2 ~ str_c('0', country_code),
    T ~ country_code)) %>% 
  left_join(iso) %>% 
  readr::write_rds('paula/data/df_wvs.rds') 

df_nathan <- haven::read_dta("plough_replication/crosscountry_dataset.dta") %>% 
  rename(iso3 = isocode) %>% 
  left_join(iso) %>% 
  left_join(df_wdi) %>% 
  left_join(df_wvs) %>% 
  rename(lfpf = labor_force_female_percent_of_total_labor_force,
         employment_agriculture = employment_in_agriculture_female_percent_of_female_employment,
         fertility = fertility_rate_total_births_per_woman,
         maternal_mortality = maternal_mortality_ratio_modeled_estimate_per_100_000_live_births) %>% 
  readr::write_rds('paula/data/nathan_augmentented.rds') %>% 
  haven::write_dta('paula/data/nathan_augmentented.dta', version = 13)
