clear all
set more off

cd "/Users/paulapereda/econ_politica/paula/"

use "/Users/paulapereda/econ_politica/paula/data/nathan_augmentented.dta"

****************************************************************************************************
*********************************** Tabla III: versi—n Paula ***************************************
****************************************************************************************************

xi: reg  lfpf plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity, r
estimates store t1_a

xi: reg  lfpf plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity i.continent, r
estimates store t1_b

/*  Como en el paper, el uso de arado est‡ asociado a una menor participaci—n femenina en el mercado laboral (14 a–os m‡s actual). */

xi: reg  employment_agriculture plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity, r
estimates store t1_c

xi: reg  employment_agriculture plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity  i.continent, r
estimates store t1_d

/*  Esto est‡ bueno para introducir mi trabajo y la hip—tesis central, el uso de arado est‡ asociado a una menor participaci—n femenina 
en el empleo relativo al agro. Igual no es significativo. */

xi: reg  fertility plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity  lfpf, r
estimates store t1_e

xi: reg  fertility plow agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity i.continent  lfpf, r
estimates store t1_f

/* Como en el paper "Fertility and the Plough (2011)", el efecto del uso de arado en coeficiente asociado a la fertilidad es negativo
 y significativo. Esta ser’a la primera 'otra' dimensi—n que yo utilizar’a. */

esttab t1_a t1_b t1_c t1_d t1_e t1_f using output/tabla1.tex, b(%10.3f) se mtitles replace

****************************************************************************************************
************************************ Tabla V: versi—n Paula ****************************************
****************************************************************************************************

use "/Users/paulapereda/econ_politica/paula/data/df_wvs.dta", clear

xi: reg lfpf plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary age age_sq married i.continent if age>=15 & age<=64, cl(regioncode)
estimates store t2_a

/*  Como en el paper, el uso de arado (con una adicional set de controles) est‡ asociado a una menor participaci—n femenina en el mercado
 laboral (14 a–os m‡s actual). */

xi: reg jobs_scarce plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store t2_b

xi: reg men_better_leaders plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store t2_c

xi: reg men_better_executive plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store t2_d

xi: reg women_earns_more plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store t2_e

xi: reg women_job_children plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store t2_f

xi: reg boy_girl_university plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store t2_g

xi: reg confidence_women_org plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store t2_h

esttab t2_a t2_b t2_c t2_d t2_e t2_f t2_g t2_h using output/tabla2.tex, b(%10.3f) se mtitles replace

****************************************************************************************************
*********************************** Tabla VIII: versi—n Paula **************************************
****************************************************************************************************

************************
******** Panel A *******
************************

use "/Users/paulapereda/econ_politica/paula/data/nathan_augmentented.dta", clear

reg plow plow_positive_crops plow_negative_crops agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared if lfpf~=., r 
test plow_negative_crops=plow_positive_crops
predict resid, resid

reg lfpf plow resid agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared, r 
drop resid 

xi: reg plow plow_positive_crops plow_negative_crops agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent if lfpf~=., r 
test plow_negative_crops=plow_positive_crops
predict resid, resid

xi: reg lfpf plow resid agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent , r 
drop resid 

reg  plow plow_positive_crops  plow_negative_crops agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared if fertility~=., r 
test plow_negative_crops=plow_positive_crops
predict resid, resid

reg fertility plow resid agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared  lfpf, r 
drop resid 

xi: reg  plow plow_positive_crops plow_negative_crops agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent lfpf if fertility~=., r 
test plow_negative_crops=plow_positive_crops
predict resid, resid

xi: reg fertility plow resid agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent lfpf, r 
drop resid 

reg plow plow_positive_crops plow_negative_crops agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared if schooling_gpi~=., r 
test plow_negative_crops=plow_positive_crops
predict resid, resid

reg  schooling_gpi plow resid agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared, r 
drop resid 

xi: reg  plow plow_positive_crops  plow_negative_crops agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent if schooling_gpi~=., r 
test plow_negative_crops=plow_positive_crops
predict resid, resid

xi: reg  schooling_gpi plow_negative_crops plow_positive_crops resid agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent , r 
drop resid 

************************
******** Panel B *******
************************

xi: reg lfpf plow_negative_crops plow_positive_crops  agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared, r 
test plow_negative_crops plow_positive_crops
test plow_negative_crops=plow_positive_crops

xi: reg lfpf plow_negative_crops plow_positive_crops  agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent, r 
test plow_negative_crops plow_positive_crops
test plow_negative_crops=plow_positive_crops

xi: reg fertility plow_negative_crops plow_positive_crops  agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared  lfpf, r 
test plow_negative_crops plow_positive_crops
test plow_negative_crops=plow_positive_crops

xi: reg fertility plow_negative_crops plow_positive_crops  agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared  lfpf i.continent, r 
test plow_negative_crops plow_positive_crops
test plow_negative_crops=plow_positive_crops

xi: reg schooling_gpi plow_negative_crops plow_positive_crops  agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared, r 
test plow_negative_crops plow_positive_crops
test plow_negative_crops=plow_positive_crops

xi: reg schooling_gpi plow_negative_crops plow_positive_crops  agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent, r 
test plow_negative_crops plow_positive_crops
test plow_negative_crops=plow_positive_crops

************************
******** Panel C *******
************************
 
xi: ivreg2 lfpf (plow = plow_negative_crops plow_positive_crops) agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared, r first
estimates store t3_a

xi: ivreg2 lfpf (plow = plow_negative_crops plow_positive_crops) agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent, r first
estimates store t3_b

xi: ivreg2 fertility (plow = plow_negative_crops plow_positive_crops) agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared  lfpf, r first
estimates store t3_c

xi: ivreg2 fertility (plow = plow_negative_crops plow_positive_crops) agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent  lfpf, r first
estimates store t3_d

xi: ivreg2 schooling_gpi (plow =  plow_negative_crops plow_positive_crops) agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared , r first
estimates store t3_e

xi: ivreg2 schooling_gpi (plow =  plow_negative_crops plow_positive_crops) agricultural_suitability tropical_climate large_animals political_hierarchies economic_complexity ln_income ln_income_squared i.continent, r first
estimates store t3_f

esttab t3_a t3_b t3_c t3_d t3_e t3_f using output/tabla3.tex, b(%10.3f) se mtitles replace
