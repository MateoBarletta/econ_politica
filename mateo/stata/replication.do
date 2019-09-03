capture log close
clear all
set more off

cd "C:\Users\Usuario\Desktop\Trabajo Final\Replication_Materials"

*** TABLA 3 ***
use "crosscountry_dataset.dta", clear
keep if continent == "South America"

xi: reg  flfp2000 	 plow agricultural_suitability large_animals tropical_climate political_hierarchies economic_complexity ln_income ln_income_squared, r
xi: reg  flfp2000 	 plow agricultural_suitability large_animals tropical_climate political_hierarchies economic_complexity ln_income ln_income_squared i.country, r

xi: reg  female_ownership 	 plow agricultural_suitability large_animals tropical_climate political_hierarchies economic_complexity ln_income ln_income_squared, r
xi: reg  female_ownership 	 plow agricultural_suitability large_animals tropical_climate political_hierarchies economic_complexity ln_income ln_income_squared i.country, r

xi: reg  women_politics 	 plow agricultural_suitability large_animals tropical_climate political_hierarchies economic_complexity ln_income ln_income_squared, r
xi: reg  women_politics 	 plow agricultural_suitability large_animals tropical_climate political_hierarchies economic_complexity ln_income ln_income_squared i.country, r

*** TABLA 4 ***
use "WVS_dataset.dta", clear
keep if continent == "South America"

xi: reg FLFP15_64			plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary age age_sq married i.continent if age>=15 & age<=64, cl(regioncode)
estimates store col1
xi: reg jobs_scarce	   		plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store col2
xi: reg men_pol_leaders		plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store col3

xi: reg FLFP15_64 			plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.countrycode if age>=15 & age<=64 , cl(regioncode)
estimates store col5
xi: reg jobs_scarce	  		plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex	 	i.countrycode, cl(regioncode)
estimates store col6
xi: reg men_pol_leaders		plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex		i.countrycode , cl(regioncode)
estimates store col7

*Tabla 4 LaTeX
cd "C:\Users\Usuario\Desktop\Trabajo Final\proyecto\econ_politica\mateo\data"

esttab col1 col2 col3 col5 col6 col7 using internas/tabla44.tex, b(%10.3f) se mtitles replace ///
    title(Estimaciones MCO a nivel individual - Base original subset América Latina\label{tab1})
