#---------------------------------------------------
#      Empirical Exercise
#      Effect of Coethnicity on primary school completion
#      Codes based on Callaway and Sant'Anna (2021)
#---------------------------------------------------
#---------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------
# Load data
DHS_ElectrificationWater  <- read_csv(file.path(datasets,"DHS_ElectrificationWater.csv"))

#--------------------------------------------------------------------------------------------
# Callaway and Sant'Anna (2021) procedure
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Formula for covarites
# xformla <- ~ urban + female 

#--------------------------------------------------------------------------------------------
# Using not-yet treated
# feols(AccessToWater ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters)
CS_ny_unc <- did::att_gt(yname="AccessToWater",
                   tname="birth_year",
                   idname="EthClusters",
                   gname="first.treat",
                   xformla=~1,
                   #xformla = xformla,
                   control_group="notyettreated",
                   data=DHS_ElectrificationWater,
                   #anticipation = 1,
                   base_period = "universal",
                   panel=FALSE,
                   bstrap=TRUE,
                   cband=TRUE,
                   allow_unbalanced_panel = TRUE)

summary(CS_ny_unc)
ggdid(CS_ny_unc, ncol = 3, title = "Access to clean drinking water DiD based on unconditional PTA and using not-yet-treated as comparison group ")
CS_es_ny_unc <- aggte(CS_ny_unc, type = "dynamic", min_e = -20, max_e = 20, na.rm = TRUE)
summary(CS_es_ny_unc)
ggdid(CS_es_ny_unc,  title = "Event-study aggregation \n Access to Clean Water DiD based on unconditional PTA and using not-yet-treated as comparison group ")


#--------------------------------------------------------------------------------------------
# Using never treated
CS_never_unc <- did::att_gt(yname="AccessToWater",
                         tname="birth_year",
                         idname="EthClusters",
                         gname="first.treat",
                         xformla=~1,
                         #anticipation = 1,
                         #base_period = "universal",
                         #xformla = xformla,
                         control_group="notyettreated",
                         data=DHS_ElectrificationWater,
                         #anticipation = 1,
                         base_period = "universal",
                         panel=FALSE,
                         bstrap=TRUE,
                         cband=TRUE,
                         allow_unbalanced_panel = TRUE)
summary(CS_never_unc)
ggdid(CS_never_unc, ncol = 3, title = "Access to Clean Water DiD based on unconditional PTA and using never-treated as comparison group ")
CS_es_never_unc <- aggte(CS_never_unc, type = "dynamic", min_e = -20, max_e = 30, na.rm = TRUE)
summary(CS_es_never_unc)
ggdid(CS_es_never_unc,  title = "Event-study aggregation \n Access to Clean Water DiD based on unconditional PTA and using never-treated as comparison group ")

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Optional customization
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Select never-treated subgroups

# Given years
years <- c(1895, 1901, 1915, 1932, 1933, 1934, 1935, 1937, 1939, 1940, 1941, 1944, 
           1945, 1946, 1948, 1949, 1950, 1951, 1952, 1953, 1954, 1993)
# Create the list of tidy data frames and the group list
list_of_df <- list()
group_list <- c()

for(year in years){
  assign(paste("CS_never_unc", year, sep=""), tidy(CS_never_unc) %>% filter(group == year))
  
  list_of_df <- c(list_of_df, list(get(paste("CS_never_unc", year, sep=""))))
  group_list <- c(group_list, year)
}

# list_of_df contains the data frames for the given years
# group_list contains the years you have provided


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
    ggtitle(paste("Group", group_list[i], ": Access to Clean Water DiD based on unconditional PTA Using Never Treated"))
  
  # Print the plot
  print(plot)
  
  # Save the plot
  filename <- paste0("group_water_", group_list[i], "_DiD_unconditional_PTA.png")
  ggsave(paste0(figures_wd,"/", filename), plot, width = 12, height = 4, units = "in")
  ggsave(paste0(thesis_plots,"/", filename), plot, width = 12, height = 4, units = "in")
}

# Select not-yet-treated subgroups
# Given years
years <- c(1895, 1901, 1915, 1932, 1933, 1934, 1935, 1937, 1939, 1940, 1941, 1944, 
           1945, 1946, 1948, 1949, 1950, 1951, 1952, 1953, 1954, 1993)

# Create the list of tidy data frames and the group list
list_of_df <- list()
group_list <- c()

for(year in years){
  assign(paste("CS_ny_unc", year, sep=""), tidy(CS_ny_unc) %>% filter(group == year))
  
  list_of_df <- c(list_of_df, list(get(paste("CS_ny_unc", year, sep=""))))
  group_list <- c(group_list, year)
}

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
    ggtitle(paste("Group", group_list[i], ": Access to Clean Water DiD based on unconditional PTA Using Not-Yet Treated"))
  
  # Print the plot
  print(plot)
  
  # Save the plot
  filename <- paste0("group_water_", group_list[i], "_DiD_unconditional_PTA_ny.png")
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
  ggtitle("Event-study plot:\n Access to Clean Water DiD using not-yet-treated as comparison group")


plot_CS_ny_cond_es 

ggsave(paste0(figures_wd,"/water_DiD-ny-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/water_DiD-ny-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(here("my_paper/figure","water_DiD-ny-treat-es.pdf"),
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
  ggtitle("Event-study plot:\n Access to Clean Water DiD using never treated as comparison group")


plot_CS_never_uncond_es 

ggsave(paste0(figures_wd,"/water_DiD-never-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/water_DiD-never-treat-es.png"), width = 12, height = 4, units = "in")

ggsave(here("my_paper/figure","water_DiD-ny-treat-es.pdf"),
       plot_CS_never_uncond_es,  
       dpi = 500,
       width = 14, 
       height = 7)

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
# Extended Two-way FE
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------
# water
mod5 =
  etwfe(
    fml  = AccessToWater ~ 1, #urban + female + age, # outcome ~ controls
    tvar = birth_year,        # time variable
    gvar = first.treat, # group variable
    data = DHS_ElectrificationWater,       # dataset
    vcov = ~EthClusters#,  # vcov adjustment (here: clustered),
    #ivar =  EthClusters
    )
mod5_es <- emfx(mod5, type = "event")


ggplot(mod5_es |> filter(event <= 20), aes(x = event, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0) +
  geom_line(linewidth = 0.5, alpha = 2, colour = "black") +
  geom_pointrange(col = "black") +
  labs(x = "Years post treatment", y = "Effect on access to clean drinking water")+
  theme(axis.text.y = element_text(size = 9)) +
  theme(axis.text.x = element_text(size = 9)) +
  theme(axis.title = element_text(color = "black",  size = 9)) +
  theme(plot.title = ggtext::element_markdown(size = 9, color = "black", hjust = 0, lineheight = 1.2)) +
  ggtitle(paste("Extended Two Way Fixed Effects DiD on drinking water"))
ggsave(paste0(figures_wd,"/water-DiD-etwfe-treat-es.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/water-DiD-etwfe-treat-es.png"), width = 12, height = 4, units = "in")


