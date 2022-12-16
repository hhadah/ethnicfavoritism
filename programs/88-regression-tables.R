# This a script to
# run a regression


# open data
DHS_PrimSchl                   <- read_dta(file.path(datasets,"DHS_PrimSchl.dta"))
DHS_Infantdata_polity_coethnic <- read_dta(file.path(datasets,"DHS_Infantdata_polity_coethnic.dta"))
DHS_ElectrificationWater       <- read_dta(file.path(datasets,"DHS_ElectrificationWater.dta"))
DHS_Wealth                     <- read_dta(file.path(datasets,"DHS_Wealth.dta"))

# By generation
reg1 <- list(
  "\\specialcell{(1) \\\\ $Schooling$}" = feols(CompletedPrimaryEdu ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_PrimSchl, vcov = ~EthClusters)
  
)


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
  "nobs",      "N",             0,
  "FE: birth_year", "Birth Year FE", 0,
  "FE: age", "Age FE", 0,
  "FE: EthClusters", "Country Specific Ethnic FE", 0,
  "std.error.type", "Standard Errors", 0,
  #"r.squared", "R squared", 3
)

modelsummary(reg1, fmt = 2,  
             coef_map = cm,
             add_rows = mean_row,
             gof_map = gm,
             escape = F,
             #gof_omit = 'DF|Deviance|R2|AIC|BIC|Log.Lik.|F|Std.Errors',
             stars= c('***' = 0.01, '**' = 0.05, '*' = 0.1),
             title = "Self-Reported Hispanic Identity and Bias: By Generation \\label{regtab-bygen-01}") %>%
  kable_styling(bootstrap_options = c("hover", "condensed"), 
                latex_options = c("scale_down", "hold_position")
  ) %>%
  footnote(number = c("\\\\footnotesize{I include controls for sex, quartic age, parental education.}",
                      "\\\\footnotesize{Standard errors are clustered on the state level.}"),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  )

regression_tab <- modelsummary(reg1, fmt = 2,  
                               output = "latex", 
                               coef_map = cm,
                               add_rows = mean_row,
                               gof_map = gm,
                               escape = F,
                               #gof_omit = 'DF|Deviance|R2|AIC|BIC|Log.Lik.|F|Std.Errors',
                               stars= c('***' = 0.01, '**' = 0.05, '*' = 0.1),
                               title = "Relationship Between Bias and Self-Reported Hispanic Identity: By Generation \\label{regtab-bygen-01}") %>%
  kable_styling(bootstrap_options = c("hover", "condensed"), 
                latex_options = c("scale_down", "hold_position")
  ) %>%
  footnote(number = c("\\\\footnotesize{Each column is an estimation of a heterogeneous effect of regression (\\\\ref{eq:identity_reg_bias}) by 
                      generation with region × year fixed effects. 
                      I include controls for sex, quartic age, fraction of Hispanics in a state, and parental education.
                      I also added parents' (HH, HW, and WH) and grandparents' (HHHH, HHHW, HHWH, etc.) type dummy variables to the regression
                      on second and third generation immigrants, where H is objectively Hispanic (born in a Spanish Speaking Country) and W is objectively White (native born). 
                      Standard errors are clustered on the state level.}",
                      "\\\\footnotesize{The samples include children ages 17 and below who live in intact families. 
                      First-generation Hispanic immigrant children that were born in a 
                      Spanish speaking county. Native born second-generation Hispanic 
                      immigrant children with at least one parent born in a Spanish speaking 
                      country. Finally, native born third-generation Hispanic immigrant children 
                      with native born parents and at least one grandparent born in a Spanish 
                      speaking country.}",
                      "\\\\footnotesize{Data source is the 2004-2021 Current Population Survey.}"),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T, fixed_small_size = T
  )


regression_tab %>%
  save_kable(file.path(tables_wd,"tab04-regression_tab_bygen_skin.tex"))

regression_tab %>%
  save_kable(file.path(thesis_tabs,"tab04-regression_tab_bygen_skin.tex"))
regression_tab %>%
  save_kable(file.path(Identity_paper_tab,"tab51-regression_tab_bygen_skin.tex"))

gm <- tibble::tribble(
  ~raw,        ~clean,          ~fmt,
  "nobs",      "N",             0,
  # "FE: region", "Region FE", 0,
  # "FE: year", "Year FE", 0,
  "FE: region:year", "Year\\timesRegion FE", 0,
  # "std.error.type", "Standard Errors", 0,
  #"r.squared", "R squared", 3
)
regression_tab <- modelsummary(reg1, fmt = 2,  
                               output = "latex", 
                               coef_map = cm,
                               add_rows = mean_row,
                               escape = F,
                               gof_map = gm,
                               #gof_omit = 'DF|Deviance|R2|AIC|BIC|Log.Lik.|F|Std.Errors',
                               stars= c('***' = 0.01, '**' = 0.05, '*' = 0.1)) %>%
  kable_styling(bootstrap_options = c("hover", "condensed"), 
                latex_options = c("hold_position"),
                full_width = F, font_size = 10
  ) |>
  row_spec(c(1,2), bold = T, color = "black", background = "yellow")


regression_tab %>%
  save_kable(file.path(pres_tabs,"tab04-regression_tab_bygen_skin.tex"))

rm(CPS_IAT)
