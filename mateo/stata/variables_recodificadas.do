*variables recodificadas*
/* Está Ud. muy de acuerdo(1), de acuerdo (1), en desacuerdo (0) o muy en desacuerdo (0) con la frases que le voy a leer:
P67ST.C Es mejor que la mujer se concentre en el hogar y el hombre en el trabajo......... 
P67WVSST.D Los hombres son mejores líderes políticos que las mujeres................. */

*nivel pais*
use "internas\df_latin_2009_pais_recod.dta", clear
xi: reg mujer_politica		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
xi: reg mujer_politica		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, cl(region)
estimates store columna1

xi: reg mujer_hogar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
xi: reg mujer_hogar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, cl(region)
estimates store columna2

*nivel region*
use "internas\df_latin_2009_region_recod.dta", clear
xi: reg mujer_politica		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
xi: reg mujer_politica		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, cl(region)
estimates store columna1

xi: reg mujer_hogar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
xi: reg mujer_hogar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, cl(region)
estimates store columna2
