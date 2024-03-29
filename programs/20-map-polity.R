# Import data with geographic variables from Github

Polity <- read_dta(file.path(raw,"PolityHeadsofStates.dta")) |> 
  mutate(Polity_ord = as.ordered(case_when(polity2 >5                    ~ "Democracy",
                                           polity2 <= 5 & polity2 > 0    ~ "Open Anocracy",
                                           polity2 <= 0 & polity2 > -5   ~ "Closed Anocracy",
                                           polity2 <= -5 & polity2 > -10 ~ "Autocracy",
                                           polity2 == -5 | polity2 == -10
                                           | polity2 == -10 ~ "Failed or Occupied")))


# this "world" dataframe has the lat & long info needed for mapping.
africa <- st_as_sf(map('world', plot = TRUE, fill = TRUE,
                       regions = c("Nigeria",
                                   "Ethiopia",
                                   "Egypt",
                                   "Democratic Republic of the Congo",
                                   "South Africa",
                                   "Tanzania",
                                   "Kenya",
                                   "Sudan",
                                   "Algeria",
                                   "Uganda",
                                   "Morocco",
                                   "Mozambique",
                                   "Ghana",
                                   "Angola",
                                   "Ivory Coast",
                                   "Madagascar",
                                   "Cameroon",
                                   "Niger",
                                   "Burkina Faso",
                                   "Mali",
                                   "Malawi",
                                   "Zambia",
                                   "Somalia",
                                   "Senegal",
                                   "Chad",
                                   "Zimbabwe",
                                   "South Sudan",
                                   "Rwanda",
                                   "Tunisia",
                                   "Guinea",
                                   "Benin",
                                   "Burundi",
                                   "Togo",
                                   "Eritrea",
                                   "Sierra Leone",
                                   "Libya",
                                   "Republic of the Congo",
                                   "Central African Republic",
                                   "Liberia",
                                   "Mauritania",
                                   "Namibia",
                                   "Botswana",
                                   "Gambia",
                                   "Equatorial Guinea",
                                   "Lesotho",
                                   "Gabon",
                                   "Guinea-Bissau",
                                   "Mauritius",
                                   "Eswatini",
                                   "Djibouti",
                                   "Comoros",
                                   "Cape Verde",
                                   "São Tomé and Príncipe",
                                   "Seychelles"
                                   ))) # ne_countries(continent = "Africa", returnclass = "sf", scale = "medium") 
library(countrycode)
africa <- africa %>% 
  mutate(cowcode = countrycode(ID, origin = 'country.name', destination = 'cown') )

# join IAT + lowercase names to df that has lat & long
Polity <- inner_join(Polity, 
                                   africa, 
                                   by = "cowcode") 
Polity <- st_as_sf(Polity)

# Polity <- Polity |> 
#   filter(polity2 <= 10 & polity2 >= -10)
## # ggplot without labels -----


for (year_map in seq(1980,2000,5)) {
  map <- ggplot() + geom_sf(data = Polity |> filter(year == year_map), 
                            aes(fill = polity2), 
                            color = "white")+
    geom_sf(data = africa, 
            color = 'black', 
            fill = NA,
            size = 0.5) +
    scale_fill_viridis_d(option = "D", direction = -1, name = "Polity IV"
    ) +
    theme_customs_map() +
    theme(legend.position = "bottom")
  map
  ggsave(path = figures_wd, filename = paste0(year_map,".png"), width = 8, height = 5.5, 
         units = c("in"), dpi = 600)
  ggsave(path = thesis_plots, 
         filename = paste0(year_map,".png"), width = 8, height = 5.5, 
         units = c("in"), dpi = 600)
  
}

map1980 <- ggplot() + geom_sf(data = Polity |> filter(year == 1980), 
                          aes(fill = Polity_ord), 
                          color = "white")+#labs(title = "Polity IV in 1980") +
  geom_sf(data = africa, 
          color = 'black', 
          fill = NA,
          size = 0.5) +
  scale_fill_manual(values = c("#2166ACFF", "#92C5DEFF", "#F4A582FF","#B2182BFF"),
                    name = "Polity IV",
                       breaks = c("Democracy",
                                  "Open Anocracy",
                                  "Closed Anocracy",
                                  "Autocracy",
                                  "Failed or Occupied")
  ) +
  theme_customs_map() +
  theme(legend.position = "bottom")

map1980
ggsave(path = figures_wd, filename = paste0(1980,".png"), width = 8, height = 5.5,
       units = c("in"), dpi = 600)
ggsave(path = thesis_plots,
       filename = paste0(1980,".png"), width = 8, height = 5.5,
       units = c("in"), dpi = 600)

map1985 <- ggplot() + geom_sf(data = Polity |> filter(year == 1985), 
                              aes(fill = Polity_ord), 
                              color = "white")+#labs(title = "Polity IV in 1985") +
  geom_sf(data = africa, 
          color = 'black', 
          fill = NA,
          size = 0.5) +
  scale_fill_manual(values = c("#2166ACFF", "#92C5DEFF", "#F4A582FF","#B2182BFF"),
                    name = "Polity IV",
                    breaks = c("Democracy",
                               "Open Anocracy",
                               "Closed Anocracy",
                               "Autocracy",
                               "Failed or Occupied")
  ) +
  theme_customs_map() +
  theme(legend.position = "bottom")
map1985
ggsave(path = figures_wd, filename = paste0(1985,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)
ggsave(path = thesis_plots, 
       filename = paste0(1985,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)

map1990 <- ggplot() + geom_sf(data = Polity |> filter(year == 1990), 
                              aes(fill = Polity_ord), 
                              color = "white")+#labs(title = "Polity IV in 1990") +
  geom_sf(data = africa, 
          color = 'black', 
          fill = NA,
          size = 0.5) +
  scale_fill_manual(values = c("#2166ACFF", "#92C5DEFF", "#F4A582FF","#B2182BFF"),
                    name = "Polity IV",
                    breaks = c("Democracy",
                               "Open Anocracy",
                               "Closed Anocracy",
                               "Autocracy",
                               "Failed or Occupied")
  ) +
  theme_customs_map() +
  theme(legend.position = "bottom")
map1990
ggsave(path = figures_wd, filename = paste0(1990,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)
ggsave(path = thesis_plots, 
       filename = paste0(1990,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)

map1995 <- ggplot() + geom_sf(data = Polity |> filter(year == 1995), 
                              aes(fill = Polity_ord), 
                              color = "white")+#labs(title = "Polity IV in 1995") +
  geom_sf(data = africa, 
          color = 'black', 
          fill = NA,
          size = 0.5) +
  scale_fill_manual(values = c("#2166ACFF", "#92C5DEFF", "#F4A582FF","#B2182BFF"),
                    name = "Polity IV",
                    breaks = c("Democracy",
                               "Open Anocracy",
                               "Closed Anocracy",
                               "Autocracy",
                               "Failed or Occupied")
  ) +
  theme_customs_map() +
  theme(legend.position = "bottom")
map1995
ggsave(path = figures_wd, filename = paste0(1995,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)
ggsave(path = thesis_plots, 
       filename = paste0(1995,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)

map2000 <- ggplot() + geom_sf(data = Polity |> filter(year == 2000), 
                              aes(fill = Polity_ord), 
                              color = "white")+#labs(title = "Polity IV in 2000") +
  geom_sf(data = africa, 
          color = 'black', 
          fill = NA,
          size = 0.5) +
  scale_fill_manual(values = c("#2166ACFF", "#92C5DEFF", "#F4A582FF","#B2182BFF"),
                    name = "Polity IV",
                    breaks = c("Democracy",
                               "Open Anocracy",
                               "Closed Anocracy",
                               "Autocracy",
                               "Failed or Occupied")
  ) +
  theme_customs_map() +
  theme(legend.position = "bottom")
map2000
ggsave(path = figures_wd, filename = paste0(2000,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)
ggsave(path = thesis_plots, 
       filename = paste0(2000,".png"), width = 8, height = 5.5, 
       units = c("in"), dpi = 600)

ggarrange(map1980, map1985, map1990, map1995, map2000, ncol=2, nrow=3, common.legend = TRUE, legend="bottom")

