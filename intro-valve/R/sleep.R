sleep <- function(port, secs) {
  httr2::request(
    paste0("127.0.0.1:", port, "/sleep?zzz=", secs)
  ) |>
    httr2::req_perform() |>
    httr2::resp_body_string()
}


library(furrr)
plan(multisession, workers = 10)

start <- Sys.time()
furrr::future_map(1:10, ~ sleep(3000, 2))
multi_total <- Sys.time() - start
multi_total


start <- Sys.time()
furrr::future_map(1:10, ~ sleep(24817, 2))
(total <- Sys.time() - start)
