# devtools::install_github("EL-BID/Libreria-R-Numeros-para-el-Desarrollo", force = TRUE)
# devtools::install_github("EL-BID/Agregador-de-indicadores", force = TRUE)
library(tidyverse)
library(agregadorindicadores)

iso <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv") %>% 
  select(iso2 = `alpha-2`,
         iso3 = `alpha-3`,
         country_code = `country-code`)

iso2 <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv") %>% 
  select(iso2 = `alpha-2`,
         iso3 = `alpha-3`,
         country_code = `country-code`,
         continent = region)

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

plow <- haven::read_dta("plough_replication/crosscountry_dataset.dta") %>% 
  rename(iso3 = isocode) %>% 
  left_join(iso) %>% 
  select(plow, tropical_climate, economic_complexity, political_hierarchies, agricultural_suitability, 
         large_animals, iso2)

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

income <- ai(indicator = "NY.GDP.PCAP.KD", country = paises_paper, startdate = 2014, enddate = 2014) %>% 
  clean_structure_wdi() %>% 
  transmute(iso2,
            ln_income = log(gdp_per_capita_constant_2010_us),
            ln_income2 = ln_income^2)

df_wvs <- haven::read_dta("paula/data/WV6_Data_Stata_v20180912.dta") %>% 
  transmute(country_code = V2,
            sex = V240,
            age = V242,
            married = V57,
            primary = V248,
            secondary = V248,
            jobs_scarce = V45,
            women_earns_more = V47,
            women_job_children = V50,
            men_better_leaders = V51,
            boy_girl_university = V52,
            men_better_executive = V53,
            confidence_women_org = V123,
            regioncode = V256,
            countrycode = country_code) %>% 
  sjlabelled::remove_all_labels() %>% 
  mutate(country_code = as.character(country_code)) %>% 
  mutate(country_code = case_when(
    nchar(country_code) == 2 ~ str_c("0", country_code),
    T ~ country_code)) %>% 
  mutate(sex = case_when(
    sex < 0 ~ NA_real_,
    T ~ sex
  )) %>% 
  mutate(age = case_when(
    age < 0 ~ NA_real_,
    T ~ age
  )) %>% 
  mutate(age_sq = age^2) %>% 
  mutate(married = case_when(
    married == 1 ~ 1,
    T ~ 0
  )) %>% 
  mutate(primary = case_when(
    primary == 3 ~ 1,
    primary == 4 ~ 1,
    primary == 5 ~ 1,
    primary == 6 ~ 1,
    primary == 7 ~ 1,
    primary == 8 ~ 1,
    primary == 9 ~ 1,
    T ~ 0
  )) %>% 
  mutate(secondary = case_when(
    secondary == 5 ~ 1,
    secondary == 6 ~ 1,
    secondary == 7 ~ 1,
    secondary == 8 ~ 1,
    secondary == 9 ~ 1,
    T ~ 0 
  )) %>% 
  mutate(jobs_scarce = case_when(
    jobs_scarce < 0 ~ NA_real_,
    T ~ jobs_scarce
  )) %>% 
  mutate(women_earns_more = case_when(
    women_earns_more < 0 ~ NA_real_,
    T ~ women_earns_more
  )) %>% 
  mutate(women_job_children = case_when(
    women_job_children < 0 ~ NA_real_,
    T ~ women_job_children
  )) %>% 
  mutate(men_better_leaders = case_when(
    men_better_leaders < 0 ~ NA_real_,
    T ~ men_better_leaders
  )) %>% 
  mutate(boy_girl_university  = case_when(
    boy_girl_university < 0 ~ NA_real_,
    T ~ boy_girl_university
  )) %>% 
  mutate(men_better_executive = case_when(
    men_better_executive < 0 ~ NA_real_,
      T ~ men_better_executive
  )) %>% 
  mutate(confidence_women_org = case_when(
    confidence_women_org < 0 ~ NA_real_,
    T ~ confidence_women_org
  )) %>% 
  mutate(regioncode = case_when(
    regioncode < 0 ~ NA_real_,
    T ~ regioncode
  )) %>% 
  mutate(regioncode = as.character(regioncode)) %>% 
  left_join(iso2) %>% 
  left_join(income) %>% 
  left_join(labor_force) %>% 
  left_join(plow) %>% 
  rename(lfpf = labor_force_female_percent_of_total_labor_force) %>% 
  readr::write_rds('paula/data/df_wvs.rds') 

haven::write_dta(df_wvs, 'paula/data/df_wvs.dta', version = 13)

df_nathan <- haven::read_dta("plough_replication/crosscountry_dataset.dta") %>% 
  rename(iso3 = isocode) %>% 
  left_join(iso) %>% 
  left_join(df_wdi) %>% 
  rename(lfpf = labor_force_female_percent_of_total_labor_force,
         employment_agriculture = employment_in_agriculture_female_percent_of_female_employment,
         fertility = fertility_rate_total_births_per_woman,
         maternal_mortality = maternal_mortality_ratio_modeled_estimate_per_100_000_live_births)

readr::write_rds(df_nathan, 'paula/data/nathan_augmentented.rds') 
haven::write_dta(df_nathan, 'paula/data/nathan_augmentented.dta', version = 13)
