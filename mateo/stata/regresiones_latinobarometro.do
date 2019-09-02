capture log close
clear all
set more off

cd "C:\Users\Usuario\Desktop\Trabajo Final\proyecto\econ_politica\mateo\data"

**LATINOBAROMETRO 2009**
/* Está Ud. muy de acuerdo(1), de acuerdo (2), en desacuerdo (3) o muy en desacuerdo (4) con la frases que le voy a leer:
P67ST.C Es mejor que la mujer se concentre en el hogar y el hombre en el trabajo
P67WVSST.D Los hombres son mejores líderes políticos que las mujeres */

*nivel pais*
use "internas\df_latin_2009_pais.dta", clear

xi: reg mujer_politica		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
estimates store columna1

xi: reg mujer_hogar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
estimates store columna2

*nivel region*
use "internas\df_latin_2009_region.dta", clear

xi: reg mujer_politica		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
xi: estimates store columna6

xi: reg mujer_hogar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 reedad, r
estimates store columna7


**LATINOBAROMETRO 2015**
/* ¿Está Ud. muy de acuerdo (1), de acuerdo (2), en desacuerdo (3) o muy endesacuerdo (4) con las siguientes afirmaciones?
P69ST.A Las mujeres deben trabajar sólo si la pareja no gana suficiente */

*nivel pais*
use "internas\df_latin_2015_pais.dta", clear

xi: reg preg_trabajar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 edad, r
estimates store columna3

*nivel region*
use "internas\df_latin_2015_region.dta", clear

xi: reg preg_trabajar		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 edad, r
estimates store columna8

**LATINOBAROMETRO 2017**
/* Ahora le voy a nombrar una serie de frases, dígame si está Ud. muy de acuerdo (1), de acuerdo (2), en desacuerdo (3) o muy en desacuerdo (4) con las siguientes afirmaciones?
P53N.F Que la mitad de los miembros del parlamento tengan que ser mujeres 
P53N.G Que la mitad de los jueces tengan que ser mujeres */

*nivel pais*
use "internas\df_latin_2017_pais.dta", clear

xi: reg preg_parlamento		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 edad sexo, r
estimates store columna4

xi: reg preg_jueces		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 edad sexo, r
estimates store columna5

*nivel region*
use "internas\df_latin_2017_region.dta", clear

xi: reg preg_parlamento		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 edad sexo, r
estimates store columna9

xi: reg preg_jueces		plow ln_income ln_income_squared economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability educ1 edad sexo, r
estimates store columna10
