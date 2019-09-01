capture log close
clear all
set more off

cd "C:\Users\Usuario\Desktop\Gabiloncho\Replication_Materials"

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
estimates store columna1
xi: reg jobs_scarce	   		plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store columna2
xi: reg men_pol_leaders		plow ln_income ln_income2 economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex i.continent, cl(regioncode)
estimates store columna3

xi: reg FLFP15_64 			plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.countrycode if age>=15 & age<=64 , cl(regioncode)
estimates store columna5
xi: reg jobs_scarce	  		plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex	 	i.countrycode, cl(regioncode)
estimates store columna6
xi: reg men_pol_leaders		plow economic_complexity large_animals political_hierarchies tropical_climate agricultural_suitability primary secondary  age age_sq married i.sex		i.countrycode , cl(regioncode)
estimates store columna7

*Tabla 4 LaTeX
esttab columna1 columna2 columna3 columna5 columna6 columna7 using tabla4.tex, wide replace ///
  title(Tabla 4: Estimacion MCO a nivel individual\label{tab4})