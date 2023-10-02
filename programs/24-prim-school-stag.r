#---------------------------------------------------
#      Empirical Exercise
#      Effect of Coethnicity on primary school completion
#      Codes based on Callaway and Sant'Anna (2021)
#---------------------------------------------------
#-----------------------------------------------------------------------------
# Load packages
#-----------------------------------------------------------------------------
# Libraries
# Load libraries
library(ggplot2)
library(here)
library(ggthemes)
library(patchwork)
library(ggtext)
library(foreign)
library(tidyverse)
library(dplyr)
## Load external packages
library(foreign)
library(remotes)
#install_github("bcallaway11/BMisc")
library(BMisc)
library(did)
library(gridExtra)
library(knitr)
library(ggpubr)


library(bacondecomp) 
library(TwoWayFEWeights)
library(fixest)
library(glue)
library(plm)
#---------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------
# Load data
DHS_PrimSchl  <- read_csv(file.path(datasets,"DHS_PrimSchl.csv"))

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# ggplot2 theme
# Set ggplot theme
theme_set(
  #theme_clean() + 
  theme_classic() +
    theme(
      panel.background = element_rect(fill = "transparent"), # bg of the panel
      plot.background = element_rect(fill = "white", color = NA), # bg of the plot
      legend.background = element_rect(color = "white"),
      legend.box.background = element_rect(fill = "transparent"), # get rid of legend panel bg
      panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      panel.spacing = unit(10, "lines"))
)
feols(CompletedPrimaryEdu ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_PrimSchl, vcov = ~EthClusters)

#--------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------
# Start the analysis
#---------------------------------------------------------------------------------------
# Get TWFE coefficient
twfe_unc <- fixest::feols(CompletedPrimaryEdu ~ coethnic + urban + female | birth_year + age + EthClusters, 
                      data = DHS_PrimSchl,
                      #weights = ~pop, 
                      cluster = ~EthClusters)
summary(twfe_unc)
#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------
# # Get de Chaisemartin and D'Haultfoeuille Decomposition
dCDH_decomp <- twowayfeweights(
  df = DHS_PrimSchl, 
  Y = "CompletedPrimaryEdu", 
  G = "first.treat",
  T = "birth_year", 
  D ="coethnic",
  cmd_type =  "feTR"
)

# Create min_year to omit it in the TWFE regression
min_year <- min(DHS_PrimSchl$rel_year)
# Formula we will use
formula_twfe_es_unc <- as.formula(glue::glue("CompletedPrimaryEdu ~ i(rel_year, ref=c(-1, {min_year})) | first.treat + birth_year"))


# estimate the TWFE coefficients
twfe_es_unc <- fixest::feols(formula_twfe_es_unc, data = DHS_PrimSchl, cluster = ~EthClusters)
summary(twfe_es_unc)
# Put the TWFE coefficients in a tibble that is easy to plot
twfe_es_unc <- broom::tidy(twfe_es_unc) %>%
  filter(str_detect(term, "rel_year::")) %>% 
  mutate(
    rel_year = as.numeric(str_remove(term, "rel_year::")),
  ) %>%
  filter(rel_year <= 15 & rel_year >= -15) %>%
  select(event.time = rel_year, 
         estimate,
         std.error) %>%
  add_row(event.time = -1, 
          estimate = 0,
          std.error =0)  %>%
  mutate( point.conf.low  = estimate - stats::qnorm(1 - .05/2) * std.error,
          point.conf.high = estimate + stats::qnorm(1 - .05/2) * std.error)


twfe_es_unc
#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------
# TWFE with covariates

# Formula we will use
formula_twfe_es_cond <- as.formula(glue::glue("CompletedPrimaryEdu ~ i(rel_year, ref=c(-1, {min_year})) + 
                                               urban + female | first.treat + birth_year"))


# estimate the TWFE coefficients
twfe_es_cond <- fixest::feols(formula_twfe_es_cond, data = DHS_PrimSchl, cluster = ~EthClusters)
summary(twfe_es_cond)
# Put the TWFE coefficients in a tibble that is easy to plot
twfe_es_cond <- broom::tidy(twfe_es_cond) %>%
  filter(str_detect(term, "rel_year::")) %>% 
  mutate(
    rel_year = as.numeric(str_remove(term, "rel_year::")),
  ) %>%
  filter(rel_year <= 15 & rel_year >= -15) %>%
  select(event.time = rel_year, 
         estimate,
         std.error) %>%
  add_row(event.time = -1, 
          estimate = 0,
          std.error =0)  %>%
  mutate( point.conf.low  = estimate - stats::qnorm(1 - .05/2) * std.error,
          point.conf.high = estimate + stats::qnorm(1 - .05/2) * std.error)


twfe_es_cond



#--------------------------------------------------------------------------------------------
# Callaway and Sant'Anna (2021) procedure
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Formula for covarites
xformla <- ~ urban + female 
#--------------------------------------------------------------------------------------------
# Using not-yet treated
feols(CompletedPrimaryEdu ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_PrimSchl, vcov = ~EthClusters)

CS_ny_unc <- did::att_gt(yname="CompletedPrimaryEdu",
                   tname="birth_year",
                   idname="EthClusters",
                   gname="first.treat",
                   xformla=~1,
                   #xformla = xformla,
                   control_group="notyettreated",
                   data=DHS_PrimSchl,
                   #anticipation = 1,
                   base_period = "universal",
                   panel=FALSE,
                   bstrap=TRUE,
                   cband=TRUE,
                   allow_unbalanced_panel = TRUE)

summary(CS_ny_unc)
ggdid(CS_ny_unc, ncol = 3, title = "DiD based on unconditional PTA and using not-yet-treated as comparison group ")
CS_es_ny_unc <- aggte(CS_ny_unc, type = "dynamic", min_e = -20, max_e = 20, na.rm = TRUE)
summary(CS_es_ny_unc)
ggdid(CS_es_ny_unc,  title = "Event-study aggregation \n DiD based on unconditional PTA and using not-yet-treated as comparison group ")


#--------------------------------------------------------------------------------------------
# Using never treated
CS_never_unc <- did::att_gt(yname="CompletedPrimaryEdu",
                         tname="birth_year",
                         idname="EthClusters",
                         gname="first.treat",
                         xformla=~1,
                         #anticipation = 1,
                         #base_period = "universal",
                         #xformla = xformla,
                         control_group="notyettreated",
                         data=DHS_PrimSchl,
                         #anticipation = 1,
                         base_period = "universal",
                         panel=FALSE,
                         bstrap=TRUE,
                         cband=TRUE,
                         allow_unbalanced_panel = TRUE)
summary(CS_never_unc)
ggdid(CS_never_unc, ncol = 3, title = "DiD based on unconditional PTA and using never-treated as comparison group ")
CS_es_never_unc <- aggte(CS_never_unc, type = "dynamic", min_e = -20, max_e = 30, na.rm = TRUE)
summary(CS_es_never_unc)
ggdid(CS_es_never_unc,  title = "Event-study aggregation \n DiD based on unconditional PTA and using never-treated as comparison group ")

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Optional customization
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Select never-treated subgroups

CS_never_unc6 <- tidy(CS_never_unc) %>%
  filter( group == 1957)

CS_never_unc7 <- tidy(CS_never_unc) %>%
  filter( group == 1958)

CS_never_unc8 <- tidy(CS_never_unc) %>%
  filter( group == 1959)

CS_never_unc9 <- tidy(CS_never_unc) %>%
  filter( group == 1962)

CS_never_unc10<- tidy(CS_never_unc) %>%
  filter( group == 1963)

CS_never_unc11<- tidy(CS_never_unc) %>%
  filter( group == 1965)

CS_never_unc13<- tidy(CS_never_unc) %>%
  filter( group == 1971)

CS_never_unc15 <- tidy(CS_never_unc) %>%
  filter(group == 1974)

CS_never_unc16 <- tidy(CS_never_unc) %>%
  filter(group == 1975)

CS_never_unc17 <- tidy(CS_never_unc) %>%
  filter(group == 1977)

CS_never_unc18 <- tidy(CS_never_unc) %>%
  filter(group == 1979)

CS_never_unc19 <- tidy(CS_never_unc) %>%
  filter(group == 1980)

CS_never_unc21 <- tidy(CS_never_unc) %>%
  filter(group == 1984)

CS_never_unc22 <- tidy(CS_never_unc) %>%
  filter(group == 1986)

CS_never_unc23 <- tidy(CS_never_unc) %>%
  filter(group == 1987)

CS_never_unc24 <- tidy(CS_never_unc) %>%
  filter(group == 1990)

CS_never_unc25 <- tidy(CS_never_unc) %>%
  filter(group == 1991)

CS_never_unc27 <- tidy(CS_never_unc) %>%
  filter(group == 1994)

CS_never_unc28 <- tidy(CS_never_unc) %>%
  filter(group == 1995)

CS_never_unc29 <- tidy(CS_never_unc) %>%
  filter(group == 1997)
#--------------------------------------------------------------------------------------------
# Customize graphs
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

# List of dataframes
list_of_df <- list(CS_never_unc6, CS_never_unc7, CS_never_unc8, CS_never_unc9, 
                   CS_never_unc10, CS_never_unc11, CS_never_unc13, 
                   CS_never_unc15, CS_never_unc16, CS_never_unc17, 
                   CS_never_unc18, CS_never_unc19, CS_never_unc21, 
                   CS_never_unc22, CS_never_unc23, CS_never_unc24, CS_never_unc25, 
                   CS_never_unc27, CS_never_unc28, CS_never_unc29)

# Group list
group_list <- c(1957, 1958, 1959,
                1962, 1963, 1965,
                1971, 1974, 1975, 1977, 1979,
                1980, 1984, 1986, 1987,
                1990, 1991, 1994, 1995, 1997)

# Loop to generate plots
for(i in seq_along(list_of_df)){
  
  # Get minimum and maximum year values
  min_year <- min(list_of_df[[i]]$time[!is.na(list_of_df[[i]]$estimate)])
  max_year <- max(list_of_df[[i]]$time[!is.na(list_of_df[[i]]$estimate)])

  plot <- ggplot(data = list_of_df[[i]], mapping = aes(x = time, y = estimate)) +
    geom_line(linewidth = 0.5, alpha = 2, colour = "black") +
    geom_vline(xintercept = group_list[i] - 0.1, color = 'grey', size = 1.2, linetype = "dotted") +
    geom_hline(yintercept = 0, colour = "black", linetype = "dotted") +
    geom_pointrange(aes(ymin = conf.low, ymax = conf.high), show.legend = FALSE, linetype= 1, size = 1.1, color = "red") +
    geom_pointrange(aes(ymin = point.conf.low, ymax = point.conf.high), show.legend = FALSE, size = 1.1) +
    xlab("Year") +
    ylab("ATT(g,t) Estimate") +
    xlim(min_year, max_year) +
    theme(axis.text.y = element_text(size = 9)) +
    theme(axis.text.x = element_text(size = 9)) +
    theme(axis.title = element_text(color = "black",  size = 9)) +
    theme(plot.title = ggtext::element_markdown(size = 9, color = "black", hjust = 0, lineheight = 1.2)) +
    ggtitle(paste("Group", group_list[i], ": DiD based on unconditional PTA Using Never Treated"))
  
  # Print the plot
  print(plot)
  
  # Save the plot
  filename <- paste0("group_", group_list[i], "_DiD_unconditional_PTA.png")
  ggsave(paste0(figures_wd,"/", filename), plot, width = 12, height = 4, units = "in")
  ggsave(paste0(thesis_plots,"/", filename), plot, width = 12, height = 4, units = "in")
}

# Select not-yet-treated subgroups
CS_ny_unc1 <- tidy(CS_ny_unc) %>%
  filter( group == 1949)

CS_ny_unc2 <- tidy(CS_ny_unc) %>%
  filter( group == 1951)

CS_ny_unc3 <- tidy(CS_ny_unc) %>%
  filter( group == 1953)

CS_ny_unc4 <- tidy(CS_ny_unc) %>%
  filter( group == 1955)

CS_ny_unc5 <- tidy(CS_ny_unc) %>%
  filter( group == 1956)

CS_ny_unc6 <- tidy(CS_ny_unc) %>%
  filter( group == 1957)

CS_ny_unc7 <- tidy(CS_ny_unc) %>%
  filter( group == 1958)

CS_ny_unc8 <- tidy(CS_ny_unc) %>%
  filter( group == 1959)

CS_ny_unc9 <- tidy(CS_ny_unc) %>%
  filter( group == 1962)

CS_ny_unc10<- tidy(CS_ny_unc) %>%
  filter( group == 1963)

CS_ny_unc11<- tidy(CS_ny_unc) %>%
  filter( group == 1965)

CS_ny_unc12<- tidy(CS_ny_unc) %>%
  filter( group == 1968)

CS_ny_unc13<- tidy(CS_ny_unc) %>%
  filter( group == 1971)

CS_ny_unc14 <- tidy(CS_ny_unc) %>%
  filter(group == 1973)

CS_ny_unc15 <- tidy(CS_ny_unc) %>%
  filter(group == 1974)

CS_ny_unc16 <- tidy(CS_ny_unc) %>%
  filter(group == 1975)

CS_ny_unc17 <- tidy(CS_ny_unc) %>%
  filter(group == 1977)

CS_ny_unc18 <- tidy(CS_ny_unc) %>%
  filter(group == 1979)

CS_ny_unc19 <- tidy(CS_ny_unc) %>%
  filter(group == 1980)

CS_ny_unc20 <- tidy(CS_ny_unc) %>%
  filter(group == 1983)

CS_ny_unc21 <- tidy(CS_ny_unc) %>%
  filter(group == 1984)

CS_ny_unc22 <- tidy(CS_ny_unc) %>%
  filter(group == 1986)

CS_ny_unc23 <- tidy(CS_ny_unc) %>%
  filter(group == 1987)

CS_ny_unc24 <- tidy(CS_ny_unc) %>%
  filter(group == 1990)

CS_ny_unc25 <- tidy(CS_ny_unc) %>%
  filter(group == 1991)

CS_ny_unc26 <- tidy(CS_ny_unc) %>%
  filter(group == 1993)

CS_ny_unc27 <- tidy(CS_ny_unc) %>%
  filter(group == 1994)

CS_ny_unc28 <- tidy(CS_ny_unc) %>%
  filter(group == 1995)

CS_ny_unc29 <- tidy(CS_ny_unc) %>%
  filter(group == 1997)


#--------------------------------------------------------------------------------------------
# Customize graphs
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

# List of dataframes
list_of_df <- list(CS_ny_unc7,  CS_ny_unc8, 
                   CS_ny_unc9,  CS_ny_unc10, CS_ny_unc11,
                   CS_ny_unc13, CS_ny_unc15, CS_ny_unc17, CS_ny_unc18,
                   CS_ny_unc19, CS_ny_unc21, CS_ny_unc23,
                   CS_ny_unc24, CS_ny_unc25, CS_ny_unc27, CS_ny_unc28, CS_ny_unc29)

# Group list
group_list <- c(1958, 1959,
                1962, 1963, 1965,
                1971, 1974, 1977, 1979,
                1980, 1984, 1987,
                1990, 1991, 1994, 1995, 1997)

# Create a named list to hold the filtered data frames

# Loop to generate plots
for(i in seq_along(list_of_df)){
  
  # Get minimum and maximum year values
  min_year <- min(list_of_df[[i]]$time[!is.na(list_of_df[[i]]$estimate)])
  max_year <- max(list_of_df[[i]]$time[!is.na(list_of_df[[i]]$estimate)])

  plot <- ggplot(data = list_of_df[[i]], mapping = aes(x = time, y = estimate)) +
    geom_line(linewidth = 0.5, alpha = 2, colour = "black") +
    geom_vline(xintercept = group_list[i] - 0.1, color = 'grey', size = 1.2, linetype = "dotted") +
    geom_hline(yintercept = 0, colour = "black", linetype = "dotted") +
    geom_pointrange(aes(ymin = conf.low, ymax = conf.high), show.legend = FALSE, linetype= 1, size = 1.1, color = "red") +
    geom_pointrange(aes(ymin = point.conf.low, ymax = point.conf.high), show.legend = FALSE, size = 1.1) +
    xlab("Year") +
    ylab("ATT(g,t) Estimate") +
    xlim(min_year, max_year) +
    theme(axis.text.y = element_text(size = 9)) +
    theme(axis.text.x = element_text(size = 9)) +
    theme(axis.title = element_text(color = "black",  size = 9)) +
    theme(plot.title = ggtext::element_markdown(size = 9, color = "black", hjust = 0, lineheight = 1.2)) +
    ggtitle(paste("Group", group_list[i], ": DiD based on unconditional PTA Using Not-Yet Treated"))
  
  # Print the plot
  print(plot)
  
  # Save the plot
  filename <- paste0("group_", group_list[i], "_DiD_unconditional_PTA_ny.png")
  ggsave(paste0(figures_wd,"/", filename), plot, width = 12, height = 4, units = "in")
  ggsave(paste0(thesis_plots,"/", filename), plot, width = 12, height = 4, units = "in")
}

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Event-study plots
CS_never_uncond_es <- tidy(CS_es_never_unc)
CS_ny_uncond_es <- tidy(CS_es_ny_unc)

plot_CS_ny_cond_es<-  ggplot(data = CS_ny_uncond_es,
                      mapping = aes(x = event.time, y = estimate)) +
  geom_line(size = 0.5, alpha = 2, colour = "black") +
  geom_vline(xintercept = 0-0.1, color = 'grey', size = 1.2, linetype = "dotted") + 
  geom_hline(yintercept = 0, colour="black",  linetype = "dotted")+

  geom_pointrange(aes(ymin = conf.low, ymax = conf.high), show.legend = FALSE, linetype= 1, size = 1.1,
                  color = "red")+
  geom_pointrange(aes(ymin = point.conf.low, ymax = point.conf.high), show.legend = FALSE, size = 1.1)+
  xlab("Year") +
  ylab("ATT(g,t) Estimate") +
  #ylim(-.22,.1)+
  theme(axis.text.y = element_text(size = 9))+
  theme(axis.text.x = element_text(size = 9)) +
  theme(axis.title = element_text(color="black",  size = 9))+
  theme(plot.title=ggtext::element_markdown(size=9,
                                            #face = "bold",
                                            color="black",
                                            hjust=0,
                                            lineheight=1.2)
  )+
  ggtitle("Event-study plot:\n DiD using not-yet-treated as comparison group")


plot_CS_ny_cond_es 

ggsave(paste0(figures_wd,"/DiD-ny-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/DiD-ny-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(here("my_paper/figure","DiD-ny-treat-es.pdf"),
       plot_CS_ny_cond_es,  
       dpi = 500,
       width = 14, 
       height = 7)


plot_CS_never_uncond_es<-  ggplot(data = CS_never_uncond_es,
                      mapping = aes(x = event.time, y = estimate)) +
  geom_line(size = 0.5, alpha = 2, colour = "black") +
  geom_vline(xintercept = 0-0.1, color = 'grey', size = 1.2, linetype = "dotted") + 
  geom_hline(yintercept = 0, colour="black",  linetype = "dotted")+

  geom_pointrange(aes(ymin = conf.low, ymax = conf.high), show.legend = FALSE, linetype= 1, size = 1.1,
                  color = "red")+
  geom_pointrange(aes(ymin = point.conf.low, ymax = point.conf.high), show.legend = FALSE, size = 1.1)+
  xlab("Year") +
  ylab("ATT(g,t) Estimate") +
  #ylim(-.22,.1)+
  theme(axis.text.y = element_text(size = 9))+
  theme(axis.text.x = element_text(size = 9)) +
  theme(axis.title = element_text(color="black",  size = 9))+
  theme(plot.title=ggtext::element_markdown(size=9,
                                            #face = "bold",
                                            color="black",
                                            hjust=0,
                                            lineheight=1.2)
  )+
  ggtitle("Event-study plot:\n DiD using never treated as comparison group")


plot_CS_never_uncond_es 

ggsave(paste0(figures_wd,"/DiD-never-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/DiD-never-treat-es.png"), width = 12, height = 4, units = "in")

ggsave(here("my_paper/figure","DiD-ny-treat-es.pdf"),
       plot_CS_never_uncond_es,  
       dpi = 500,
       width = 14, 
       height = 7)