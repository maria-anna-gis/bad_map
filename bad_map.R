library(sf)
library(dplyr)
library(ggplot2)
library(extrafont)

#Load GeoJSON directly stored on my GitHub. Original source: https://gadm.org/download_country.html
towns <- st_read("https://raw.githubusercontent.com/maria-anna-gis/bad_map/main/gadm41_DEU_4.json")

#Load fonts so they can be changed
font_import(prompt = FALSE)
loadfonts()
fonts()

#Filter for any names that contain "bad"
bad <- towns %>%
  filter(!is.na(NAME_4)) %>%
  filter(grepl("bad", NAME_4, ignore.case = TRUE)) %>%
  mutate(group = "Bad")

#And then for the not bad...
good <- towns %>%
  filter(!is.na(NAME_4)) %>%
  filter(!grepl("bad", NAME_4, ignore.case = TRUE)) %>%
  mutate(group = "not Bad")

"combined" <- bind_rows(bad, good)

#present in ggplot2
ggplot(combined) +
  geom_sf(aes(fill = group), color = "grey50", size = 0.1) +
  scale_fill_manual(values = c("Bad" = "red", "not Bad" = "green")) +
  labs(
    title = "Is it Bad?",
    fill = NULL,
    caption = "Souce: GADM (https://gadm.org/data.html)" 
    ) +
  theme_minimal() +
  theme(
    plot.title = element_text(family = "Comic Sans MS-Bold", hjust = 0.5, size = 24, face = "bold"),
    plot.caption = element_text(family = "Comic Sans MS", size = 10, hjust = 1),
    legend.text = element_text(family = "Comic Sans MS", size = 16),                             
    plot.background = element_rect(fill = "white", color = NA),
  )

#to save the map
ggsave("bad_map.png", width = 10, height = 10, dpi = 300)