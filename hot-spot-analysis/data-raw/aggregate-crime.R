library(sf)
library(sfdep)
library(tidyverse)


# Atlanta boundaries & fishnet --------------------------------------------

georgia_places <- tigris::places("georgia") 

georgia_places |> 
  as_tibble() |> 
  View()


atlanta_boundary <- filter(georgia_places, NAME == "Atlanta")

st_geometry(atlanta_boundary) |> 
  plot()


# create fishnet grid
# from https://gist.github.com/JosiahParry/d0f244093eb700215d2a19e807022b60
# previous video
make_fishnet <- function(geometry, ...) {
  grd <- st_make_grid(geometry, ...) 
  index <- which(lengths(st_intersects(grd, geometry)) > 0)
  grd[index]
}


atlanta_fishnet <- make_fishnet(atlanta_boundary, 
             n = 15,
             square = FALSE,
             flat_topped = TRUE) |> 
  st_as_sf() |> 
  mutate(hex_id = row_number())


# Read & clean police data ------------------------------------------------

police_raw <- read_csv("hot-spot-analysis/data/COBRA-2022.csv") |> 
  st_as_sf(
    coords = c("long", "lat"),
    crs = 4326
  ) |> 
  st_transform(crs = st_crs(atlanta_fishnet))



# join to hex for ids 
crime_joined <- st_join(police_raw, atlanta_fishnet) 

crime_counts <- crime_joined |> 
  as_tibble() |> 
  count(hex_id, UC2_Literal) |> 
  pivot_wider(
    names_from = "UC2_Literal",
    values_from = "n",
    values_fill = 0
  ) |> 
  janitor::clean_names()

crimes_cleaned <- left_join(
  atlanta_fishnet,
  crime_counts
) |> 
  mutate(
    across(
      where(is.numeric), replace_na, 0
    )
  )



# write -------------------------------------------------------------------

st_write(
  crimes_cleaned,
  "hot-spot-analysis/data/atlanta-crimes.geojson",
  delete_dsn = TRUE
)



# notes -------------------------------------------------------------------


# NPU = neighborhood planning units
# https://cityofatlantanpu-w.org/

# IBR codes 
# come from 
# https://www.atlantapd.org/home/showpublisheddocument/2881/637062879602730000
