library(dplyr)
library(geohashTools)
library(populartimes)

park_street_loc <- c(42.35675660592967, -71.06224330327713)
park_street <- gh_encode(park_street_loc[1], park_street_loc[2], 12)

res <- text_search(
  location = park_street_loc,
  query = "espresso",
  type = "cafe",
  minprice = 3
)



loc_hashes <- res |> 
  mutate(geohash = gh_encode(lat, long, 12),
         str_dist = stringdist::stringdist(geohash, {{park_street}})) |> 
  filter(stringr::str_detect(geohash, substr({{ park_street }}, 1, 5))) |> 
  arrange(str_dist) |> 
  select(name, geohash, str_dist) 

loc_hashes |> 
  mutate(
    stringr::str_view(geohash, substr({{park_street}}, 1, 6), NA)
  ) |> 
  print(n = Inf)


rextendr::rust_function(r"-{
fn count_seq_chars(x: &str, y: &str) -> i32 {
  x.chars().zip(y.chars())
    .take_while(|a| a.0 == a.1)
    .fold(0, |acc, _| acc + 1)
}
}-")
