library(sf)
library(sfdep)
library(tidyverse)

crimes_raw <- read_sf("hot-spot-analysis/data/atlanta-crimes.geojson")

crimes_raw |> 
  as_tibble() |> 
  View()


hist(crimes_raw$larceny_from_vehicle)
hist(crimes_raw$larceny_non_vehicle)


crimes_raw |> 
  ggplot(aes(fill = burglary)) +
  geom_sf(color = "black", lwd = 0.15)


crimes_raw |> 
  ggplot(aes(fill = robbery)) +
  geom_sf(color = "black", lwd = 0.15)

# let's look at robbery
# there seems to be some middling amounts of crime in the suburbs 
# to the west, north, southwest and south 

# first need to make neighbors, and weights
# row-standardized weights ensures equal weight to each
# hexagon

crime_nbs <- crimes_raw |> 
  mutate(
    nb = st_contiguity(geometry),
    wt = st_weights(nb),
    robbery_lag = st_lag(robbery, nb, wt)
  ) 

crime_nbs |> 
  ggplot(aes(fill = robbery_lag)) +
  geom_sf(color = "black", lwd = 0.15)

# the lag shows a lot of smoothing and the amount of 
# crime in the neighborhood being a real smooth gradident
# is there any global clustering? 

global_g_test(crime_nbs$robbery, crime_nbs$nb, crime_nbs$wt)

# suggests there is clustering. low values indicates 
# there might be cold clusters
# we can calciulate the Gi using local_g_perm()

crime_hot_spots <- crime_nbs |> 
  mutate(
    Gi = local_g_perm(robbery, nb, wt, nsim = 499)
  ) |> 
  unnest(Gi)

crime_hot_spots |> 
  ggplot((aes(fill = gi))) +
  geom_sf(color = "black", lwd = 0.15) +
  scale_fill_gradient2()

# this cursory visualization is informative!
# colors are backwards and we're seeing _all_ locationns
# not just significant ones.

# lets classify these in 7 different categories
# very hot (cold), cold (hot), somewhat hot (cold), insignificant

# very = p < 0.01
# cold/hot = p <= 0.05
# somewhat = p <= 0.1


crime_hot_spots |> 
  select(gi, p_folded_sim) |> 
  mutate(
    classification = case_when(
      gi > 0 & p_folded_sim <= 0.01 ~ "Very hot",
      gi > 0 & p_folded_sim <= 0.05 ~ "Hot",
      gi > 0 & p_folded_sim <= 0.1 ~ "Somewhat hot",
      gi < 0 & p_folded_sim <= 0.01 ~ "Very cold",
      gi < 0 & p_folded_sim <= 0.05 ~ "Cold",
      gi < 0 & p_folded_sim <= 0.1 ~ "Somewhat cold",
      TRUE ~ "Insignificant"
    ),
    # we now need to make it look better :) 
    # if we cast to a factor we can make diverging scales easier 
    classification = factor(
      classification,
      levels = c("Very hot", "Hot", "Somewhat hot",
                 "Insignificant",
                 "Somewhat cold", "Cold", "Very cold")
    )
  ) |> 
  ggplot(aes(fill = classification)) +
  geom_sf(color = "black", lwd = 0.1) +
  scale_fill_brewer(type = "div", palette = 5) +
  theme_void() +
  labs(
    fill = "Hot Spot Classification",
    title = "Robbery Hot Spots in Metro Atlanta"
  )





