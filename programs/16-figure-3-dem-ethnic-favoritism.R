# This a script to
# run a regression

reg1 <- list(
  "Schooling"             = feols(CompletedPrimaryEdu ~ coethnic*Democracy + coethnic*Anocracy + urban + female | birth_year + age + EthClusters, data = DHS_PrimSchl, vcov = ~EthClusters),
  "Infant Survival"       = feols(infant_survival     ~ coethnic*Democracy + coethnic*Anocracy + kidbord + urban + kidsex | birth_year + age + EthClusters, data = DHS_Infantdata_polity_coethnic, vcov = ~EthClusters),
  "Wealth"                = feols(Richest ~ coethnic*Democracy + coethnic*Anocracy + urban + female | birth_year + age + EthClusters, data = DHS_Wealth, vcov = ~EthClusters),
  "Electrification"       = feols(Electrification ~ coethnic*Democracy + coethnic*Anocracy + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters),
  "Clean Water"           = feols(AccessToWater ~ coethnic*Democracy + coethnic*Anocracy + urban + female | birth_year + age + EthClusters, data = DHS_ElectrificationWater, vcov = ~EthClusters)
  
  
)

P5 = unname(createPalette(5,  c("#ff0000", "#00ff00", "#0000ff")))

cm <- cm <- c("coethnic:Democracy" = "$Democracy\\times Coethnic$",
              "coethnic:Anocracy"  = "$Anocracy\\times Coethnic$"
        #"frac_hispanic"  = "Fraction Hispanic"
        #"lnftotval_mom" = "Log Total Family Income"#,
        #"age" = "Age",
        #"HH" = "Both parents Hispanic",
        # "FirstGen" = "First Gen",
        # "SecondGen" = "Second Gen",
        # "ThirdGen" = "Third Generation"
) 

dat1 <- map_dfr(c(.95), function(x) {
  modelplot(reg1, conf_level = x, draw = FALSE) |> 
    mutate(.width = x) |> 
    filter(term == "coethnic × Democracy")
})

dat2 <- map_dfr(c(.95), function(x) {
  modelplot(reg1, conf_level = x, draw = FALSE) |> 
    mutate(.width = x) |> 
    filter(term == "coethnic × Anocracy")
})

p1 <- ggplot(dat1, aes(
  x = model, y = estimate,
  ymin = conf.low, ymax = conf.high, color = P5)) + 
  geom_point() + 
  geom_pointrange(aes(y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0, color = 'red', linetype = 'dotted', size = 1) +
  theme_customs() +
  theme(
    legend.position="none",
    strip.background = element_rect(
      color="black", fill="white", size=1.5
    ),
    axis.text.y  = element_text(size = 15),
    axis.text.x  = element_text(size = 15),
    axis.title.y = element_blank(),
    axis.title.x = element_text(size = 18),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(colour = "black")
  ) +
  scale_x_discrete(labels = label_wrap(10)) +
  labs(#title = "The co-ethnic effect on the outcomes of interest \nwith Ethnic Groups and Time Fixed Effects",
       x = TeX(r"( $I_{10 \geq Polity \geq 6} \times Coethnic$ )"))

p2 <- ggplot(dat2, aes(
  x = model, y = estimate,
  ymin = conf.low, ymax = conf.high, color = P5)) + 
  geom_point() + 
  geom_pointrange(aes(y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0, color = 'red', linetype = 'dotted', size = 1) +
  theme_customs() +
  theme(
    legend.position="none",
    strip.background = element_rect(
      color="black", fill="white", size=1.5
    ),
    axis.text.y  = element_text(size = 15),
    axis.text.x  = element_text(size = 15),
    axis.title.y = element_blank(),
    axis.title.x = element_text(size = 18),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(colour = "black")
  ) +
  scale_x_discrete(labels = label_wrap(10)) +
  labs(#title = "The co-ethnic effect on the outcomes of interest \nwith Ethnic Groups and Time Fixed Effects",
       x = TeX(r"( $I_{5 \geq Polity \geq -5 \times Coethnic}$ )"))
p1 / p2
ggarrange(p1, p2, nrow = 1)
ggsave(paste0(figures_wd,"/coeth_dem_ethFE.png"), width = 12, height = 4, units = "in")
ggsave(paste0(thesis_plots,"/coeth_dem_ethFE.png"), width = 12, height = 4, units = "in")
# ggsave(paste0("/Users/hhadah/Documents/GiT/website/content/workingpaper/EthnicFav","/featured"), width = 10* 1/2, height = 10 * 9 / 16 * 1/2, units = "cm", scaling = 0.5)



