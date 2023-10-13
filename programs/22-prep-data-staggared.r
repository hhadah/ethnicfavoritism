# open data
DHS_PrimSchl                   <- read_dta(file.path(datasets,"DHS_PrimSchl.dta")) |> 
  mutate(Democracy_dem_dic = (democracy_13 + democracy_12 + democracy_11 + democracy_10 + democracy_9 + democracy_8 + democracy_7)/7)
DHS_Infantdata_polity_coethnic <- read_dta(file.path(datasets,"DHS_Infantdata_polity_coethnic.dta")) |> 
  mutate(Democracy_dem_dic = (democracy))
DHS_ElectrificationWater       <- read_dta(file.path(datasets,"DHS_ElectrificationWater.dta")) |> 
  mutate(PipedWater = ifelse(AccessToWater == 4, 1, 0))
DHS_Wealth                     <- read_dta(file.path(datasets,"DHS_Wealth.dta")) |> 
  mutate(Democracy_dem_dic = (democracy_4 + democracy_3 + democracy_2 + democracy_1)/4)

# prepare data for staggarred difference
# in differences:
# Data will now varry by year, country,
# and ethnic group

# Compute first.treat before summarizing
DHS_PrimSchl <- DHS_PrimSchl %>%
  arrange(birth_year) %>%
  group_by(country, EthClusters) %>%
  mutate(first.treat = ifelse(any(coethnic == 1), min(birth_year[coethnic == 1]), Inf))

# Summarize DHS_PrimSchl
DHS_PrimSchl <- DHS_PrimSchl %>%
  group_by(birth_year, country, age, EthClusters) %>%
  summarize(
    CompletedPrimaryEdu = mean(CompletedPrimaryEdu, na.rm = TRUE),
    coethnic = mean(coethnic, na.rm = TRUE),
    urban = mean(urban, na.rm = TRUE),
    female = mean(female, na.rm = TRUE),
    Democracy = mean(Democracy, na.rm = TRUE),
    Anocracy = mean(Anocracy, na.rm = TRUE),
    Autocracy = mean(Autocracy, na.rm = TRUE),
    Polity = mean(Polity, na.rm = TRUE),
    Democracy_dem_dic = mean(Democracy_dem_dic, na.rm = TRUE),
    first.treat = first(first.treat) # Grab the first value of first.treat for each group after grouping
  ) %>%
  mutate(rel_year = birth_year - first.treat)

write_csv(DHS_PrimSchl, file.path(datasets,"DHS_PrimSchl.csv"))

DHS_Infantdata_polity_coethnic <- DHS_Infantdata_polity_coethnic %>%
  arrange(birth_year) %>%
  group_by(country, EthClusters) %>%
  mutate(first.treat = ifelse(any(coethnic == 1), min(birth_year[coethnic == 1]), Inf))

DHS_Infantdata_polity_coethnic   <- DHS_Infantdata_polity_coethnic  |> 
    group_by(birth_year, country, age, EthClusters) |>
    summarize(infant_survival     = mean(infant_survival, na.rm = TRUE),
              coethnic            = mean(coethnic, na.rm = TRUE),
              urban               = mean(urban, na.rm = TRUE),
              kidbord             = mean(kidbord, na.rm = TRUE),
              kidsex              = mean(kidsex, na.rm = TRUE),
              Democracy           = mean(Democracy,na.rm = TRUE),
              Anocracy            = mean(Anocracy,na.rm = TRUE),
              Autocracy           = mean(Autocracy,na.rm = TRUE),
              Polity              = mean(Polity,na.rm = TRUE),
              Democracy_dem_dic   = mean(Democracy_dem_dic, na.rm = TRUE),
              first.treat = first(first.treat, na.rm = TRUE) # Grab the first value of first.treat for each group after grouping
            ) %>%
  mutate(rel_year = birth_year - first.treat)
write_csv(DHS_Infantdata_polity_coethnic, file.path(datasets,"DHS_Infantdata_polity_coethnic.csv"))

DHS_Wealth <- DHS_Wealth %>%
  arrange(birth_year) %>%
  group_by(country, EthClusters) %>%
  mutate(first.treat = ifelse(any(coethnic == 1), min(birth_year[coethnic == 1]), Inf))

DHS_Wealth   <- DHS_Wealth  |> 
    group_by(birth_year, country, age, EthClusters) |>
    summarize(Richest             = mean(Richest, na.rm = TRUE),
              coethnic            = mean(coethnic, na.rm = TRUE),
              urban               = mean(urban, na.rm = TRUE),
              female              = mean(female, na.rm = TRUE),
              Democracy           = mean(Democracy,na.rm = TRUE),
              Anocracy            = mean(Anocracy,na.rm = TRUE),
              Autocracy           = mean(Autocracy,na.rm = TRUE),
              Polity              = mean(Polity,na.rm = TRUE),
              Democracy_dem_dic   = mean(Democracy_dem_dic, na.rm = TRUE),
              first.treat = first(first.treat) # Grab the first value of first.treat for each group after grouping
            ) %>%
  mutate(rel_year = birth_year - first.treat)
write_csv(DHS_Wealth, file.path(datasets,"DHS_Wealth.csv"))

DHS_ElectrificationWater <- DHS_ElectrificationWater %>%
  arrange(birth_year) %>%
  group_by(country, EthClusters) %>%
  mutate(first.treat = ifelse(any(coethnic == 1), min(birth_year[coethnic == 1]), Inf))

DHS_ElectrificationWater   <- DHS_ElectrificationWater  |> 
    group_by(birth_year, country, age, EthClusters) |>
    summarize(Electrification     = mean(Electrification, na.rm = TRUE),
              AccessToWater       = mean(AccessToWater, na.rm = TRUE),
              coethnic            = mean(coethnic, na.rm = TRUE),
              urban               = mean(urban, na.rm = TRUE),
              female              = mean(female, na.rm = TRUE),
              Democracy           = mean(Democracy,na.rm = TRUE),
              Anocracy            = mean(Anocracy,na.rm = TRUE),
              Autocracy           = mean(Autocracy,na.rm = TRUE),
              Polity              = mean(Polity,na.rm = TRUE),
              Democracy_dem_dic   = mean(Democracy_dem_dic, na.rm = TRUE),
              first.treat = first(first.treat) # Grab the first value of first.treat for each group after grouping
            ) %>%
  mutate(rel_year = birth_year - first.treat)
write_csv(DHS_ElectrificationWater, file.path(datasets,"DHS_ElectrificationWater.csv"))
