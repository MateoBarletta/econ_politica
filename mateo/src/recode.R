

df_latin_2009_region_recod <- df_latin_2009_region %>% 
  mutate(mujer_politica = case_when(mujer_politica == 2 ~ 1,
                                    mujer_politica == 3 ~ 0,
                                    mujer_politica == 4 ~ 0,
                                    TRUE ~ mujer_politica),
         mujer_hogar    = case_when(mujer_hogar == 2 ~ 1,
                                    mujer_hogar == 3 ~ 0,
                                    mujer_hogar == 4 ~ 0,
                                    TRUE ~ mujer_hogar))
df_latin_2009_pais_recod <- df_latin_2009_pais %>% 
  mutate(mujer_politica = case_when(mujer_politica == 2 ~ 1,
                                    mujer_politica == 3 ~ 0,
                                    mujer_politica == 4 ~ 0,
                                    TRUE ~ mujer_politica),
         mujer_hogar    = case_when(mujer_hogar == 2 ~ 1,
                                    mujer_hogar == 3 ~ 0,
                                    mujer_hogar == 4 ~ 0,
                                    TRUE ~ mujer_hogar))

write_dta(df_latin_2009_region_recod, "mateo/data/internas/df_latin_2009_region_recod.dta")
write_dta(df_latin_2009_pais_recod, "mateo/data/internas/df_latin_2009_pais_recod.dta")