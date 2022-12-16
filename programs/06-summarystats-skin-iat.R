# Summary statisitcs

# date: June 15th, 2022

# open data

# DHS Women recorde
DHS <- read_dta(file.path(raw,"DHS_MenWomen.dta")) |> 
  mutate(Urban               = ifelse(urban   == 1, 1, 0),
         electricity         = ifelse(electrc == 1, 1, 0),
         Literacy            = case_when(lit2 == 0 ~ 0,
                                         lit2 == 10 | lit2 == 10 |
                                         lit2 == 11 | lit2 == 12 
                                         ~ 1),
         WealthQuintile      = case_when(wealthq == 1 ~ 1,
                                         wealthq == 2 ~ 2,
                                         wealthq == 3 ~ 3,
                                         wealthq == 4 ~ 4,
                                         wealthq == 5 ~ 5),
         Poorest             = ifelse(wealthq == 1, 1, 0),
         Poorer              = ifelse(wealthq == 2, 1, 0),
         Middle              = ifelse(wealthq == 3, 1, 0),
         Richer              = ifelse(wealthq == 4, 1, 0),
         Richest             = ifelse(wealthq == 5, 1, 0),
         CompletedPrimaryEdu = ifelse(educlvl== 1 | 
                                        educlvl== 2 | 
                                        educlvl== 3, 1, 0),
         edyrtotal           = case_when(edyrtotal < 96 ~ edyrtotal),
         currwork            = case_when(currwork <= 12 &
                                         currwork >= 10 ~ 1,
                                         currwork == 0  ~ 0))

# summary stat tables by
# generation type
sumstat1 <-   tbl_summary(data = DHS,
                          include = c(age,
                                      cheb,
                                      hhmemtotal,
                                      electricity,
                                      currwork,
                                      WealthQuintile,
                                      edyrtotal,
                                      CompletedPrimaryEdu, 
                                      Urban,
                                      Literacy
                                      ),
                          statistic = list(all_continuous() ~ "{mean} \n ({sd}) \n [{min}, {max}]",
                                           all_categorical() ~ "{p}"),
                          digits = all_categorical() ~ function(x) style_number(x, digits = 2),
                          label = list(
                            age                ~ "Age",
                            cheb               ~ "Total children ever born",
                            hhmemtotal         ~ "Total number of household members",
                            electricity        ~ "Has electricity",
                            currwork           ~ "Currently working",
                            WealthQuintile     ~ "Wealth Quintile",
                            edyrtotal ~ "Total years of education",
                            CompletedPrimaryEdu ~ "Completed primary school", 
                            Urban ~ "Urban",
                            Literacy ~ "Literacy"
                            ),
                          missing = "no")

sumstat1 %>% 
  as_kable_extra(format = "latex",
                 booktabs = TRUE,
                 linesep = "",
                 escape = F,
                 caption = "Summary Statistics \\label{tabsum}") |> 
  footnote(number = c("Data source is the Demographic and Health Surveys (DHS)."),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  ) |> 
  kable_styling(bootstrap_options = c("hover", "condensed", "responsive"), 
                latex_options = "scale_down", full_width = FALSE) |> 
  # footnote(number = c("The samples include children ages 17 and below who live in intact families. First-generation Hispanic immigrant children that were born in a Spanish speaking county. Native born second-generation Hispanic immigrant children with at least one parent born in a Spanish speaking country. Finally, native born third generation Hispanic immigrant children with native born parents and at least one grand parent born in a Spanish speaking country.",
  #                     "Data source is the 2004-2021 Current Population Survey."),
  #          footnote_as_chunk = F, title_format = c("italic"),
  #          escape = F, threeparttable = T
  # ) |> 
  save_kable(file.path(tables_wd,"sumtab.tex"))

sumstat1 %>% 
  as_kable_extra(format = "latex",
                 booktabs = TRUE,
                 linesep = "",
                 escape = F,
                 caption = "Summary Statistics \\label{tabsum}") |> 
  footnote(number = c("Data source is the Demographic and Health Surveys (DHS)."),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  ) |> 
  kable_styling(bootstrap_options = c("hover", "condensed", "responsive"), 
                latex_options = "scale_down", full_width = FALSE) |> 
  # footnote(number = c("The samples include children ages 17 and below who live in intact families. First-generation Hispanic immigrant children that were born in a Spanish speaking county. Native born second-generation Hispanic immigrant children with at least one parent born in a Spanish speaking country. Finally, native born third generation Hispanic immigrant children with native born parents and at least one grand parent born in a Spanish speaking country.",
  #                     "Data source is the 2004-2021 Current Population Survey."),
  #          footnote_as_chunk = F, title_format = c("italic"),
  #          escape = F, threeparttable = T
  # ) |> 
  save_kable(file.path(thesis_tabs,"sumtab.tex"))

# DHS children recode
DHS <- read_dta(file.path(raw,"ChildRecode.dta")) |> 
  mutate(infant_mortality = ifelse(kidalive == 0 & kidagedeath <= 212, 1, 0),
         kidcurage        = case_when(kidcurage < 97 ~ kidcurage),
         KidFemale        = ifelse(kidsex == 2, 1, 0),
         edyrtotal        = case_when(edyrtotal < 96 ~ edyrtotal))
DHS <- DHS |> 
  mutate(infant_survival = 1 - infant_mortality)
# summary stat tables by
# generation type
sumstat1 <-   tbl_summary(data = DHS,
                          include = c(infant_survival,
                                      kidcurage, KidFemale,
                                      edyrtotal
                          ),
                          statistic = list(all_continuous() ~ "{mean} ({sd})",
                                           all_categorical() ~ "{p}"),
                          digits = all_categorical() ~ function(x) style_number(x, digits = 2),
                          label = list(
                            infant_survival ~ "Infant Survival",
                            KidFemale       ~ "Female Children",
                            edyrtotal       ~ "Children’s total years of education"
                          ),
                          missing = "no")

sumstat1 %>% 
  as_kable_extra(format = "latex",
                 booktabs = TRUE,
                 linesep = "",
                 escape = F,
                 caption = "Summary Statistics \\label{tabsum}") |> 
  footnote(number = c("Data source is the Demographic and Health Surveys (DHS)."),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  ) |> 
  kable_styling(bootstrap_options = c("hover", "condensed", "responsive"), 
                latex_options = "scale_down", full_width = FALSE) |> 
  # footnote(number = c("The samples include children ages 17 and below who live in intact families. First-generation Hispanic immigrant children that were born in a Spanish speaking county. Native born second-generation Hispanic immigrant children with at least one parent born in a Spanish speaking country. Finally, native born third generation Hispanic immigrant children with native born parents and at least one grand parent born in a Spanish speaking country.",
  #                     "Data source is the 2004-2021 Current Population Survey."),
  #          footnote_as_chunk = F, title_format = c("italic"),
  #          escape = F, threeparttable = T
  # ) |> 
  save_kable(file.path(tables_wd,"sumtab-1.tex"))

sumstat1 %>% 
  as_kable_extra(format = "latex",
                 booktabs = TRUE,
                 linesep = "",
                 escape = F,
                 caption = "Summary Statistics \\label{tabsum}") |> 
  footnote(number = c("Data source is the Demographic and Health Surveys (DHS)."),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  ) |> 
  kable_styling(bootstrap_options = c("hover", "condensed", "responsive"), 
                latex_options = "scale_down", full_width = FALSE) |> 
  # footnote(number = c("The samples include children ages 17 and below who live in intact families. First-generation Hispanic immigrant children that were born in a Spanish speaking county. Native born second-generation Hispanic immigrant children with at least one parent born in a Spanish speaking country. Finally, native born third generation Hispanic immigrant children with native born parents and at least one grand parent born in a Spanish speaking country.",
  #                     "Data source is the 2004-2021 Current Population Survey."),
  #          footnote_as_chunk = F, title_format = c("italic"),
  #          escape = F, threeparttable = T
  # ) |> 
  save_kable(file.path(thesis_tabs,"sumtab-1.tex"))



# polity
Polity <- read_dta(file.path(raw,"PolityHeadsofStates.dta"))
# summary stat tables by
# generation type
sumstat1 <-   tbl_summary(data = Polity,
                          include = c(polity2
                          ),
                          statistic = list(all_continuous() ~ "{mean} ({sd})",
                                           all_categorical() ~ "{p}"),
                          digits = all_categorical() ~ function(x) style_number(x, digits = 2),
                          label = list(
                            polity2 ~ "Polity IV"
                          ),
                          missing = "no")

sumstat1 %>% 
  as_kable_extra(format = "latex",
                 booktabs = TRUE,
                 linesep = "",
                 escape = F,
                 caption = "Summary Statistics \\label{tabsum}") |> 
  footnote(number = c("Data source is the Demographic and Health Surveys (DHS)."),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  ) |> 
  kable_styling(bootstrap_options = c("hover", "condensed", "responsive"), 
                latex_options = "scale_down", full_width = FALSE) |> 
  # footnote(number = c("The samples include children ages 17 and below who live in intact families. First-generation Hispanic immigrant children that were born in a Spanish speaking county. Native born second-generation Hispanic immigrant children with at least one parent born in a Spanish speaking country. Finally, native born third generation Hispanic immigrant children with native born parents and at least one grand parent born in a Spanish speaking country.",
  #                     "Data source is the 2004-2021 Current Population Survey."),
  #          footnote_as_chunk = F, title_format = c("italic"),
  #          escape = F, threeparttable = T
  # ) |> 
  save_kable(file.path(tables_wd,"sumtab-2.tex"))

sumstat1 %>% 
  as_kable_extra(format = "latex",
                 booktabs = TRUE,
                 linesep = "",
                 escape = F,
                 caption = "Summary Statistics \\label{tabsum}") |> 
  footnote(number = c("Data source is the Demographic and Health Surveys (DHS)."),
           footnote_as_chunk = F, title_format = c("italic"),
           escape = F, threeparttable = T
  ) |> 
  kable_styling(bootstrap_options = c("hover", "condensed", "responsive"), 
                latex_options = "scale_down", full_width = FALSE) |> 
  # footnote(number = c("The samples include children ages 17 and below who live in intact families. First-generation Hispanic immigrant children that were born in a Spanish speaking county. Native born second-generation Hispanic immigrant children with at least one parent born in a Spanish speaking country. Finally, native born third generation Hispanic immigrant children with native born parents and at least one grand parent born in a Spanish speaking country.",
  #                     "Data source is the 2004-2021 Current Population Survey."),
  #          footnote_as_chunk = F, title_format = c("italic"),
  #          escape = F, threeparttable = T
  # ) |> 
  save_kable(file.path(thesis_tabs,"sumtab-2.tex"))

