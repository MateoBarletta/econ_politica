clear all
set more off

cd "/Users/paulapereda/econ_politica/paula/"

use "/Users/paulapereda/econ_politica/paula/data/nathan_augmentented.dta"

****************************************************************************************************
*********************************** Tabla III: versi—n Paula ***************************************
****************************************************************************************************

xi: reg  lfpf plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity, r
xi: reg  lfpf plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity i.continent, r

/*  Como en el paper, el uso de arado est‡ asociado a una menor participaci—n femenina en el mercado laboral (14 a–os m‡s actual). */

xi: reg  employment_agriculture plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity, r
xi: reg  employment_agriculture plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity  i.continent, r

/*  Esto est‡ bueno para introducir mi trabajo y la hip—tesis central, el uso de arado est‡ asociado a una menor participaci—n femenina 
en el empleo relativo al agro. Igual no es significativo. */

xi: reg  fertility plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity, r
xi: reg  fertility plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity i.continent, r

/* Como en el paper "Fertility and the Plough (2011)", el efecto del uso de arado en coeficiente asociado a la fertilidad es negativo
 y significativo. Esta ser’a la primera 'otra' dimensi—n que yo utilizar’a. */

****************************************************************************************************
************************************ Tabla V: versi—n Paula ****************************************
****************************************************************************************************

use "/Users/paulapereda/econ_politica/paula/data/df_wvs.dta", clear

xi: reg lfpf plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary age age_sq married i.continent if age>=15 & age<=64, cl(regioncode)

xi: reg lfpf plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.countrycode if age>=15 & age<=64 , cl(regioncode)

/*  Como en el paper, el uso de arado (con una adicional set de controles) est‡ asociado a una menor participaci—n femenina en el mercado
 laboral (14 a–os m‡s actual). */

xi: reg jobs_scarce plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)

xi: reg jobs_scarce plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.countrycode, cl(regioncode)

xi: reg men_better_leaders plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)

xi: reg men_better_executive plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)

xi: reg women_earns_more plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)

xi: reg women_job_children plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)

xi: reg boy_girl_university plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)

xi: reg confidence_women_org plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
