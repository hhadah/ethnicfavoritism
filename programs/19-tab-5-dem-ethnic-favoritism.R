# This a script to
# run a regression


reg1 <- list(
  "\\specialcell{(1) \\\\ Schooling}"             = feols(CompletedPrimaryEdu ~ Democracy_dem_dic*coethnic + urban + female | birth_year + age + EthClusters, data = DHS_PrimSchl, vcov = ~EthClusters),
  "\\specialcell{(2) \\\\ Infant Survival}"       = feols(infant_survival     ~ Democracy_dem_dic*coethnic + kidbord + urban + kidsex | birth_year + age + EthClusters, data = DHS_Infantdata_polity_coethnic, vcov = ~EthClusters),
  "\\specialcell{(3) \\\\ Wealth}"                = feols(Richest ~ Democracy_dem_dic*coethnic + urban + female | birth_year + age + EthClusters, data = DHS_Wealth, vcov = ~EthClusters),
  "\\specialcell{(4) \\\\ Electrification}"       = feols(Electrification ~ Democracy_dem_dic*coethnic + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters),
  "\\specialcell{(5) \\\\ Clean Water}"           = feols(AccessToWater ~ Democracy_dem_dic*coethnic + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters)
  
  
)

# calculate means to add
# as a row
means_primschl <- DHS_PrimSchl |> 
  summarise(CompletedPrimaryEdu = mean(CompletedPrimaryEdu, na.rm = T))
means_inf      <- DHS_Infantdata_polity_coethnic |> 
  summarise(infant_survival = mean(infant_survival, na.rm = T))
means_ele      <- DHS_ElectrificationWater |> 
  summarise(Electrification = mean(Electrification, na.rm = T))
means_wat      <- DHS_ElectrificationWater |> 
  summarise(PipedWater = mean(PipedWater, na.rm = T))
means_wealth   <- DHS_Wealth |> 
  summarise(Richest = mean(Richest, na.rm = T))

mean_row <-  data.frame(Coefficients = c('Mean', round(means_primschl, digits = 3), round(means_inf, digits = 3), round(means_ele, digits = 3), round(means_wat, digits = 3), round(means_wealth, digits = 3)))

colnames(mean_row)<-LETTERS[1:6]

attr(mean_row, 'position') <- c(3)
cm <- c("Democracy_dem_dic:coethnic" = "$D-DIndex\\times Coethnic$"
        #"frac_hispanic"  = "Fraction Hispanic"
        #"lnftotval_mom" = "Log Total Family Income"#,
        #"age" = "Age",
        #"HH" = "Both parents Hispanic",
        # "FirstGen" = "First Gen",
        # "SecondGen" = "Second Gen",
        # "ThirdGen" = "Third Generation"
) 
gm <- tibble::tribble(
  ~raw,        ~clean,          ~fmt,
  "nobs",      "N",             0#,
  # "FE: birth_year", "Birth Year FE", 0,
  # "FE: age", "Age FE", 0,
  # "FE: EthClusters", "Country Specific Ethnic Group FE", 0,
  # "std.error.type", "Standard Errors", 0,
  #"r.squared", "R squared", 3
)

modelsummary(reg1, fmt = 3,
             add_rows = mean_row,
             coef_map = cm,
             gof_map = gm,
             escape = F,
             #gof_omit = 'DF|Deviance|R2|AIC|BIC|Log.Lik.|F|Std.Errors',
             stars= c('***' = 0.01, '**' = 0.05, '*' = 0.1),
             title = "Ethnic favoritism and continuous democracy measure results. \\label{tab:ethdemdic}") %>%
  kable_styling(bootstrap_options = c("hover", "condensed"), 
                latex_options = c("scale_down", "hold_position")
  ) %>%
  footnote(number = c("\\\\footnotesize{In this table, I am reporting the estimates of equation \\\\ref{eq1}. 
                      I present the results of the interaction between the coethnic variable and 
                      \\\\textit{Polity IV } groups on primary school completions in column 1, infant 
                      survival in column 2, wealth quintile in column 3, electrification in column 4 
                      and access to clean drinking water in column 4. Primary school completion is a 
                      dummy variable that is equal to one if a person completed primary school and zero otherwise. 
                      Infant survival is a dummy variable that is equal to one if an infant survived the first 12 
                      months of life. Wealth is a dummy variable that is equal to one if a person belongs to the top 
                      wealth quintile. Electrification is a dummy variable that is equal to one if a household 
                      has electricity. Finally, access to clean drinking water is a dummy variable that is equal to one if a household 
                      has access to clean piped drinking water.}",
                      "\\\\footnotesize{\\\\textit{Polity IV } score in this specification is continuous. It takes
                      values that range from most autocratic $-10$ to most democratic $10$}",
                      "\\\\footnotesize{Standard errors are clustered on ethnic groups. All 
                      results include ethnic group, time and age fixed effects.}"),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  )

regression_tab <- modelsummary(reg1, fmt = 3, 
                               output = "latex", 
                               coef_map = cm,
                               add_rows = mean_row,
                               gof_map = gm,
                               escape = F,
                               #gof_omit = 'DF|Deviance|R2|AIC|BIC|Log.Lik.|F|Std.Errors',
                               stars= c('***' = 0.01, '**' = 0.05, '*' = 0.1),
                               title = "Ethnic favoritism and continuous democracy measure results. \\label{tab:ethdemdic}") %>%
  kable_styling(bootstrap_options = c("hover", "condensed"), 
                latex_options = c("scale_down", "hold_position")
  ) %>%
  footnote(number = c("\\\\footnotesize{In this table, I am reporting the estimates of equation \\\\ref{eq1}. 
                      I present the results of the interaction between the coethnic variable and 
                      \\\\textit{Polity IV } groups on primary school completions in column 1, infant 
                      survival in column 2, wealth quintile in column 3, electrification in column 4 
                      and access to clean drinking water in column 4. Primary school completion is a 
                      dummy variable that is equal to one if a person completed primary school and 
                      zero otherwise. Infant survival is a dummy variable that is equal to one if an 
                      infant survived the first 12 months of life. Electrification is a dummy variable
                      that is equal to one if a household has electricity. Finally, access to clean 
                      drinking water is an ordinal variable that has values from 1, worst water source, to 4.}",
                      "\\\\footnotesize{\\\\textit{Polity IV } score in this specification is continuous. It takes
                      values that range from most autocratic $-10$ to most democratic $10$}",
                      "\\\\footnotesize{Standard errors are clustered on ethnic groups. All 
                      results include ethnic group, time and age fixed effects.}"),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  )


regression_tab %>%
  save_kable(file.path(tables_wd,"tab05-ethnic_demdic_ctFE.tex"))

regression_tab %>%
  save_kable(file.path(thesis_tabs,"tab05-ethnic_demdic_ctFE.tex"))


