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
DHS_Infantdata  <- read_csv(file.path(datasets,"DHS_Infantdata_polity_coethnic.csv"))

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

#--------------------------------------------------------------------------------------------
# Callaway and Sant'Anna (2021) procedure
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Formula for covarites
# xformla <- ~ urban + kidsex 

#--------------------------------------------------------------------------------------------
# Using not-yet treated
feols(infant_survival ~ coethnic + urban + kidsex | birth_year + age + EthClusters, data = DHS_Infantdata, vcov = ~EthClusters)

CS_ny_unc <- did::att_gt(yname="infant_survival",
                   tname="birth_year",
                   idname="EthClusters",
                   gname="first.treat",
                   xformla=~1,
                   #xformla = xformla,
                   control_group="notyettreated",
                   data=DHS_Infantdata,
                   #anticipation = 1,
                   base_period = "universal",
                   panel=FALSE,
                   bstrap=TRUE,
                   cband=TRUE,
                   allow_unbalanced_panel = TRUE)

summary(CS_ny_unc)
ggdid(CS_ny_unc, ncol = 3, title = "Infant Survival DiD based on unconditional PTA and using not-yet-treated as comparison group ")
CS_es_ny_unc <- aggte(CS_ny_unc, type = "dynamic", min_e = -20, max_e = 20, na.rm = TRUE)
summary(CS_es_ny_unc)
ggdid(CS_es_ny_unc,  title = "Event-study aggregation \n Infant Survival DiD based on unconditional PTA and using not-yet-treated as comparison group ")


#--------------------------------------------------------------------------------------------
# Using never treated
CS_never_unc <- did::att_gt(yname="infant_survival",
                         tname="birth_year",
                         idname="EthClusters",
                         gname="first.treat",
                         xformla=~1,
                         #anticipation = 1,
                         #base_period = "universal",
                         #xformla = xformla,
                         control_group="notyettreated",
                         data=DHS_Infantdata,
                         #anticipation = 1,
                         base_period = "universal",
                         panel=FALSE,
                         bstrap=TRUE,
                         cband=TRUE,
                         allow_unbalanced_panel = TRUE)
summary(CS_never_unc)
ggdid(CS_never_unc, ncol = 3, title = "Infant Survival DiD based on unconditional PTA and using never-treated as comparison group ")
CS_es_never_unc <- aggte(CS_never_unc, type = "dynamic", min_e = -20, max_e = 30, na.rm = TRUE)
summary(CS_es_never_unc)
ggdid(CS_es_never_unc,  title = "Event-study aggregation \n Infant Survival DiD based on unconditional PTA and using never-treated as comparison group ")

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Optional customization
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Select never-treated subgroups

CS_never_unc6 <- tidy(CS_never_unc) %>%
  filter( group == 1938)

CS_never_unc7 <- tidy(CS_never_unc) %>%
  filter( group == 1939)

CS_never_unc8 <- tidy(CS_never_unc) %>%
  filter( group == 1940)

CS_never_unc9 <- tidy(CS_never_unc) %>%
  filter( group == 1941)

CS_never_unc10 <- tidy(CS_never_unc) %>%
  filter( group == 1943)

CS_never_unc11 <- tidy(CS_never_unc) %>%
  filter( group == 1944)

CS_never_unc13 <- tidy(CS_never_unc) %>%
  filter( group == 1947)

CS_never_unc15 <- tidy(CS_never_unc) %>%
  filter(group == 1948)

CS_never_unc16 <- tidy(CS_never_unc) %>%
  filter(group == 1949)

CS_never_unc17 <- tidy(CS_never_unc) %>%
  filter(group == 1950)

CS_never_unc18 <- tidy(CS_never_unc) %>%
  filter(group == 1951)

CS_never_unc19 <- tidy(CS_never_unc) %>%
  filter(group == 1953)

CS_never_unc21 <- tidy(CS_never_unc) %>%
  filter(group == 1954)

CS_never_unc22 <- tidy(CS_never_unc) %>%
  filter(group == 1956)

CS_never_unc23 <- tidy(CS_never_unc) %>%
  filter(group == 1958)

CS_never_unc24 <- tidy(CS_never_unc) %>%
  filter(group == 1959)

CS_never_unc25 <- tidy(CS_never_unc) %>%
  filter(group == 1960)

CS_never_unc27 <- tidy(CS_never_unc) %>%
  filter(group == 1964)

CS_never_unc28 <- tidy(CS_never_unc) %>%
  filter(group == 1965)

CS_never_unc29 <- tidy(CS_never_unc) %>%
  filter(group == 1966)

CS_never_unc30 <- tidy(CS_never_unc) %>%
  filter(group == 1967)

CS_never_unc31 <- tidy(CS_never_unc) %>%
  filter(group == 1968)

CS_never_unc32 <- tidy(CS_never_unc) %>%
  filter(group == 1969)

CS_never_unc33 <- tidy(CS_never_unc) %>%
  filter(group == 1970)

CS_never_unc34 <- tidy(CS_never_unc) %>%
  filter(group == 1971)

CS_never_unc35 <- tidy(CS_never_unc) %>%
  filter(group == 1972)

CS_never_unc36 <- tidy(CS_never_unc) %>%
  filter(group == 1974)

CS_never_unc37 <- tidy(CS_never_unc) %>%
  filter(group == 1975)

CS_never_unc38 <- tidy(CS_never_unc) %>%
  filter(group == 1978)

CS_never_unc39 <- tidy(CS_never_unc) %>%
  filter(group == 1979)

CS_never_unc40 <- tidy(CS_never_unc) %>%
  filter(group == 1982)

CS_never_unc41 <- tidy(CS_never_unc) %>%
  filter(group == 1984)

CS_never_unc42 <- tidy(CS_never_unc) %>%
  filter(group == 1987)

CS_never_unc43 <- tidy(CS_never_unc) %>%
  filter(group == 1988)

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
                   CS_never_unc27, CS_never_unc28, CS_never_unc29,
                   CS_never_unc30, CS_never_unc31, CS_never_unc32,
                   CS_never_unc33, CS_never_unc34, CS_never_unc35,
                   CS_never_unc36, CS_never_unc37, CS_never_unc38,
                   CS_never_unc39, CS_never_unc40, CS_never_unc41,
                   CS_never_unc42, CS_never_unc43)

# Group list
group_list <- c(1938,
                1939,
                1940,
                1941,
                1943,
                1944,
                1947,
                1948,
                1949,
                1950,
                1951,
                1953,
                1954,
                1956,
                1958,
                1959,
                1960,
                1964,
                1965,
                1966,
                1967,
                1968,
                1969,
                1970,
                1971,
                1972,
                1974,
                1975,
                1978,
                1979,
                1982,
                1984,
                1987,
                1988)

# Loop to generate plots
for(i in seq_along(list_of_df)){
  
  # Skip if all values in the 'estimate' column are NA
  if(all(is.na(list_of_df[[i]]$std.error))){
    message(paste("Skipping DataFrame", i, "- All 'estimate' values are NA"))
    next
  }
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
    ggtitle(paste("Group", group_list[i], ": Infant Survival DiD based on unconditional PTA Using Never Treated"))
  
  # Print the plot
  print(plot)
  
  # Save the plot
  filename <- paste0("group_infant_surv_", group_list[i], "_DiD_unconditional_PTA.png")
  ggsave(paste0(figures_wd,"/", filename), plot, width = 12, height = 4, units = "in")
  ggsave(paste0(thesis_plots,"/", filename), plot, width = 12, height = 4, units = "in")
}

# Select not-yet-treated subgroups
CS_ny_unc6 <- tidy(CS_ny_unc) %>%
  filter( group == 1938)

CS_ny_unc7 <- tidy(CS_ny_unc) %>%
  filter( group == 1939)

CS_ny_unc8 <- tidy(CS_ny_unc) %>%
  filter( group == 1940)

CS_ny_unc9 <- tidy(CS_ny_unc) %>%
  filter( group == 1941)

CS_ny_unc10 <- tidy(CS_ny_unc) %>%
  filter( group == 1943)

CS_ny_unc11 <- tidy(CS_ny_unc) %>%
  filter( group == 1944)

CS_ny_unc13 <- tidy(CS_ny_unc) %>%
  filter( group == 1947)

CS_ny_unc15 <- tidy(CS_ny_unc) %>%
  filter(group == 1948)

CS_ny_unc16 <- tidy(CS_ny_unc) %>%
  filter(group == 1949)

CS_ny_unc17 <- tidy(CS_ny_unc) %>%
  filter(group == 1950)

CS_ny_unc18 <- tidy(CS_ny_unc) %>%
  filter(group == 1951)

CS_ny_unc19 <- tidy(CS_ny_unc) %>%
  filter(group == 1953)

CS_ny_unc21 <- tidy(CS_ny_unc) %>%
  filter(group == 1954)

CS_ny_unc22 <- tidy(CS_ny_unc) %>%
  filter(group == 1956)

CS_ny_unc23 <- tidy(CS_ny_unc) %>%
  filter(group == 1958)

CS_ny_unc24 <- tidy(CS_ny_unc) %>%
  filter(group == 1959)

CS_ny_unc25 <- tidy(CS_ny_unc) %>%
  filter(group == 1960)

CS_ny_unc27 <- tidy(CS_ny_unc) %>%
  filter(group == 1964)

CS_ny_unc28 <- tidy(CS_ny_unc) %>%
  filter(group == 1965)

CS_ny_unc29 <- tidy(CS_ny_unc) %>%
  filter(group == 1966)

CS_ny_unc30 <- tidy(CS_ny_unc) %>%
  filter(group == 1967)

CS_ny_unc31 <- tidy(CS_ny_unc) %>%
  filter(group == 1968)

CS_ny_unc32 <- tidy(CS_ny_unc) %>%
  filter(group == 1969)

CS_ny_unc33 <- tidy(CS_ny_unc) %>%
  filter(group == 1970)

CS_ny_unc34 <- tidy(CS_ny_unc) %>%
  filter(group == 1971)

CS_ny_unc35 <- tidy(CS_ny_unc) %>%
  filter(group == 1972)

CS_ny_unc36 <- tidy(CS_ny_unc) %>%
  filter(group == 1974)

CS_ny_unc37 <- tidy(CS_ny_unc) %>%
  filter(group == 1975)

CS_ny_unc38 <- tidy(CS_ny_unc) %>%
  filter(group == 1978)

CS_ny_unc39 <- tidy(CS_ny_unc) %>%
  filter(group == 1979)

CS_ny_unc40 <- tidy(CS_ny_unc) %>%
  filter(group == 1982)

CS_ny_unc41 <- tidy(CS_ny_unc) %>%
  filter(group == 1984)

CS_ny_unc42 <- tidy(CS_ny_unc) %>%
  filter(group == 1987)

CS_ny_unc43 <- tidy(CS_ny_unc) %>%
  filter(group == 1988)

#--------------------------------------------------------------------------------------------
# Customize graphs
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

# List of dataframes
list_of_df <- list(CS_ny_unc6, CS_ny_unc7, CS_ny_unc8, CS_ny_unc9, 
                   CS_ny_unc10, CS_ny_unc11, CS_ny_unc13, 
                   CS_ny_unc15, CS_ny_unc16, CS_ny_unc17, 
                   CS_ny_unc18, CS_ny_unc19, CS_ny_unc21, 
                   CS_ny_unc22, CS_ny_unc23, CS_ny_unc24, CS_ny_unc25, 
                   CS_ny_unc27, CS_ny_unc28, CS_ny_unc29,
                   CS_ny_unc30, CS_ny_unc31, CS_ny_unc32,
                   CS_ny_unc33, CS_ny_unc34, CS_ny_unc35,
                   CS_ny_unc36, CS_ny_unc37, CS_ny_unc38,
                   CS_ny_unc39, CS_ny_unc40, CS_ny_unc41,
                   CS_ny_unc42, CS_ny_unc43)

# Group list
group_list <- c(1938,
                1939,
                1940,
                1941,
                1943,
                1944,
                1947,
                1948,
                1949,
                1950,
                1951,
                1953,
                1954,
                1956,
                1958,
                1959,
                1960,
                1964,
                1965,
                1966,
                1967,
                1968,
                1969,
                1970,
                1971,
                1972,
                1974,
                1975,
                1978,
                1979,
                1982,
                1984,
                1987,
                1988)

# Create a named list to hold the filtered data frames

# Loop to generate plots
for(i in seq_along(list_of_df)){
  # Skip if all values in the 'estimate' column are NA
  if(all(is.na(list_of_df[[i]]$std.error))){
    message(paste("Skipping DataFrame", i, "- All 'estimate' values are NA"))
    next
  }
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
    ggtitle(paste("Group", group_list[i], ": Infant Survival DiD based on unconditional PTA Using Not-Yet Treated"))
  
  # Print the plot
  print(plot)
  
  # Save the plot
  filename <- paste0("group_infant_surv_", group_list[i], "_DiD_unconditional_PTA_ny.png")
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
  ggtitle("Event-study plot:\n Infant Survival DiD using not-yet-treated as comparison group")


plot_CS_ny_cond_es 

ggsave(paste0(figures_wd,"/infant_surv_DiD-ny-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/infant_surv_DiD-ny-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(here("my_paper/figure","infant_surv_DiD-ny-treat-es.pdf"),
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
  ggtitle("Event-study plot:\n Infant Survival DiD using never treated as comparison group")


plot_CS_never_uncond_es 

ggsave(paste0(figures_wd,"/infant_surv_DiD-never-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/infant_surv_DiD-never-treat-es.png"), width = 12, height = 4, units = "in")

ggsave(here("my_paper/figure","infant_surv_DiD-ny-treat-es.pdf"),
       plot_CS_never_uncond_es,  
       dpi = 500,
       width = 14, 
       height = 7)
