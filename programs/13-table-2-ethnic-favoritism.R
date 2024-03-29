# This a script to
# run a regression

# By generation
reg1 <- list(
  "\\specialcell{(1) \\\\ Schooling}"             = feols(CompletedPrimaryEdu ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_PrimSchl, vcov = ~EthClusters),
  "\\specialcell{(2) \\\\ Infant Survival}"       = feols(infant_survival     ~ coethnic + kidbord + urban + kidsex | birth_year + age + EthClusters, data = DHS_Infantdata_polity_coethnic, vcov = ~EthClusters),
  "\\specialcell{(3) \\\\ Wealth}"                = feols(Richest ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_Wealth, vcov = ~EthClusters),
  "\\specialcell{(4) \\\\ Electrification}"       = feols(Electrification ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters),
  "\\specialcell{(5) \\\\ Clean Water}"           = feols(AccessToWater ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters)
  
  
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
cm <- c("coethnic" = "Coethnic"
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
  # "FE: EthClusters", "Country Specific Ethnic FE", 0,
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
             title = "Ethnic favoritism results \\label{tab:eth}") %>%
  kable_styling(bootstrap_options = c("hover", "condensed"), 
                latex_options = c("scale_down", "hold_position")
  ) %>%
  footnote(number = c("\\\\footnotesize{In this table, I am reporting the estimates of equation \\\\ref{eqFR1}. 
                      I present the results of the effect of ethnic favoritism on primary school completions 
                      in column 1, infant survival in column 2, wealth quintile in column 3, electrification in 
                      column 4 and access to clean drinking water in column 4. Primary school completion is a 
                      dummy variable that is equal to one if a person completed primary school and zero otherwise. 
                      Infant survival is a dummy variable that is equal to one if an infant survived the first 12 
                      months of life. Electrification is a dummy variable that is equal to one if a household 
                      has electricity. Finally, access to clean drinking water is an ordinal variable that has 
                      values from 1, worst water source, to 4.}",
                      "\\\\footnotesize{Standard errors are clustered on country specific ethnic groups. All results include ethnic group, time and age fixed effects.}"),
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
                               title = "Ethnic favoritism results \\label{tab:eth}") %>%
  kable_styling(bootstrap_options = c("hover", "condensed"), 
                latex_options = c("scale_down", "hold_position")
  ) %>%
  footnote(number = c("\\\\footnotesize{In this table, I am reporting the estimates of equation \\\\ref{eqFR1}. 
                      I present the results of the effect of ethnic favoritism on primary school completions 
                      in column 1, infant survival in column 2, top wealth quintile in column 3, electrification in 
                      column 4 and access to clean drinking water in column 4. Primary school completion is a 
                      dummy variable that is equal to one if a person completed primary school and zero otherwise. 
                      Infant survival is a dummy variable that is equal to one if an infant survived the first 12 
                      months of life. Wealth is a dummy variable that is equal to one if a person belongs to the top 
                      wealth quintile. Electrification is a dummy variable that is equal to one if a household 
                      has electricity. Finally, access to clean drinking water is a dummy variable that is equal to one if a household 
                      has access to clean piped drinking water.}",
                      "\\\\footnotesize{Standard errors are clustered on country specific ethnic groups. All results include ethnic group, time and age fixed effects.}"),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  )


regression_tab %>%
  save_kable(file.path(tables_wd,"tab02-ethnic_fav_tab_ethFE.tex"))

regression_tab %>%
  save_kable(file.path(thesis_tabs,"tab02-ethnic_fav_tab_ethFE.tex"))


#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Extended Two-way FE
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

# primary school 
mod =
  etwfe(
    fml  = CompletedPrimaryEdu ~ urban + female + age, # outcome ~ controls
    tvar = birth_year,        # time variable
    gvar = first.treat, # group variable
    data = DHS_PrimSchl,       # dataset
    vcov = ~EthClusters,  # vcov adjustment (here: clustered),
    ivar =  EthClusters
    )
mod_es <- emfx(mod, type = "event")

ggplot(mod_es, aes(x = event, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0) +
  geom_pointrange(col = "darkcyan") +
  labs(x = "Years post treatment", y = "Effect on primary school completion")
ggsave(paste0(figures_wd,"/DiD-etwfe-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/DiD-etwfe-treat-es.png"), width = 12, height = 4, units = "in")

emfx(mod)

# Infant survival
mod2 =
  etwfe(
    fml  = infant_survival     ~ coethnic + kidbord + urban + kidsex, # outcome ~ controls
    tvar = birth_year,        # time variable
    gvar = first.treat, # group variable
    data = DHS_Infantdata_polity_coethnic,       # dataset
    vcov = ~EthClusters,  # vcov adjustment (here: clustered),
    ivar =  EthClusters
    )
mod2_es <- emfx(mod2, type = "event")


ggplot(mod2_es, aes(x = event, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0) +
  geom_pointrange(col = "darkcyan") +
  labs(x = "Years post treatment", y = "Effect on infant survival")

# electrification
mod4 =
  etwfe(
    fml  = Electrification ~ urban + female + age, # outcome ~ controls
    tvar = birth_year,        # time variable
    gvar = first.treat, # group variable
    data = DHS_ElectrificationWater,       # dataset
    vcov = ~EthClusters,  # vcov adjustment (here: clustered),
    ivar =  EthClusters
    )
mod4_es <- emfx(mod4, type = "event")


ggplot(mod4_es, aes(x = event, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0) +
  geom_pointrange(col = "darkcyan") +
  labs(x = "Years post treatment", y = "Effect on electriication")

# water
mod5 =
  etwfe(
    fml  = AccessToWater ~ urban + female + age, # outcome ~ controls
    tvar = birth_year,        # time variable
    gvar = first.treat, # group variable
    data = DHS_ElectrificationWater,       # dataset
    vcov = ~EthClusters,  # vcov adjustment (here: clustered),
    ivar =  EthClusters
    )
mod5_es <- emfx(mod5, type = "event")


ggplot(mod5_es, aes(x = event, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0) +
  geom_pointrange(col = "darkcyan") +
  labs(x = "Years post treatment", y = "Effect on access to clean drinking water")

# wealth
mod3 =
  etwfe(
    fml  = Richest ~ urban + female + age, # outcome ~ controls
    tvar = birth_year,        # time variable
    gvar = first.treat, # group variable
    data = DHS_Wealth,       # dataset
    vcov = ~EthClusters,  # vcov adjustment (here: clustered),
    ivar =  EthClusters
    )
mod3_es <- emfx(mod3, type = "event")


ggplot(mod3_es, aes(x = event, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0) +
  geom_pointrange(col = "darkcyan") +
  labs(x = "Years post treatment", y = "Effect on belonging to the top wealth quintile")

emfx(mod)
