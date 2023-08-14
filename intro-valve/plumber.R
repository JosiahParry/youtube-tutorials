library(plumber)

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

#* sleep for some time
#* @param zzz how long to sleep for
#* @get /sleep
function(zzz) {
    Sys.sleep(zzz)
    paste0("I slept for ", zzz, " seconds")
}

