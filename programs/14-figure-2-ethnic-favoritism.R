# This a script to
# run a regression

# By generation
reg1 <- list(
  "Schooling"             = feols(CompletedPrimaryEdu ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_PrimSchl, vcov = ~EthClusters),
  "Infant Survival"       = feols(infant_survival     ~ coethnic + kidbord + urban + kidsex | birth_year + age + EthClusters, data = DHS_Infantdata_polity_coethnic, vcov = ~EthClusters),
  "Wealth"                = feols(Richest ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_Wealth, vcov = ~EthClusters),
  "Electrification"       = feols(Electrification ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters),
  "Clean Water"           = feols(AccessToWater ~ coethnic + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters)
  
  
)

P5 = unname(createPalette(5,  c("#ff0000", "#00ff00", "#0000ff")))

cm <- c("coethnic" = "Coethnic"
        #"frac_hispanic"  = "Fraction Hispanic"
        #"lnftotval_mom" = "Log Total Family Income"#,
        #"age" = "Age",
        #"HH" = "Both parents Hispanic",
        # "FirstGen" = "First Gen",
        # "SecondGen" = "Second Gen",
        # "ThirdGen" = "Third Generation"
) 

dat <- map_dfr(c(.9), function(x) {
  modelplot(reg1, conf_level = x, draw = FALSE) |> 
    mutate(.width = x) |> 
    filter(term == "coethnic")
})

ggplot(dat, aes(
  y = model, x = estimate,
  xmin = conf.low, xmax = conf.high,
  color = P5)) + 
  geom_point() + 
  geom_pointrange(aes(x = estimate, xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 0, color = 'red', linetype = 'dotted', size = 1) +
  theme_customs() +
  theme(
    legend.position="none",
    strip.background = element_rect(
      color="black", fill="white", size=1.5
    ),
    axis.text.y  = element_text(size = 15),
    axis.text.x  = element_text(size = 15),
    axis.title.y = element_blank(),
    axis.title.x = element_text(size = 15),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(colour = "black")
  ) +
  labs(title = "The co-ethnic effect on the outcomes of interest \nwith Ethnic Groups and Time Fixed Effects",
       x     = "Estimates with 95% Confidence Interval")


ggsave(paste0(figures_wd,"/coeth_ethFE.png"), width = 10, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/coeth_ethFE.png"), width = 10, height = 4, units = "in")



