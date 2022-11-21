library(sf)
library(sfdep)
library(tidyverse)

data(guerry, package = "sfdep")

View(guerry)

st_geometry(guerry) |> 
  plot()

gg_crime_obs <- ggplot(guerry, aes(fill = crime_pers)) +
  geom_sf(color = "black", lwd = 0.15) +
  scale_fill_viridis_c(limits = range(guerry$crime_pers)) +
  theme_void()


crime_lags <- guerry |> 
  mutate(
    nb = st_contiguity(geometry),
    wt = st_weights(nb),
    crime_lag = st_lag(crime_pers, nb, wt)
  ) 

gg_crime_lag <- ggplot(crime_lags, aes(fill = crime_lag)) +
  geom_sf(color = "black", lwd = 0.15) +
  scale_fill_viridis_c(limits = range(guerry$crime_pers)) +
  theme_void()


hist(crime_lags$crime_pers)
hist(crime_lags$crime_lag)
mean(crime_lags$crime_pers)


patchwork::wrap_plots(gg_crime_obs, gg_crime_lag)
