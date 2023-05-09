

# X vals
# 1 0 0 0 1 1 0 1 1 0 0 0 1 0 0 1 0 1 1 1 0 0 0 0 1 1 1 0 1 0 0 0 R
# 1 0 0 0 1 1 0 1 1 0 0 0 1 0 0 1 0 1 1 1 0 0 0 0 1 1 1 1 1 1 1 1 Rust

# Y vals
# 1 1 0 0 0 0 1 0 1 1 1 0 0 0 0 0 1 0 1 1 0 1 1 1 0 1 1 0 1 1 0 1 R
# 1 1 0 0 0 0 1 0 1 1 1 0 0 0 0 0 1 0 1 1 0 1 1 1 1 0 1 1 1 1 1 1 Rust


# interleaved
# 1 1 0 1 0 0 0 0 1 0 1 0 0 1 1 0 1 1 0 1 0 1 0 0 1 0 0 0 0 0 1 0 0 1 1 0 1 1 1 1 0 0 0 1 0 1 0 1 1 0 1 1 1 1 0 0 1 1 0 1 0 0 0 1 R
# 1 1 0 1 0 0 0 0 1 0 1 0 0 1 1 0 1 1 0 1 0 1 0 0 1 0 0 0 0 0 1 0 0 1 1 0 1 1 1 1 0 0 0 1 0 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1


# https://yatmanwong.medium.com/geohash-implementation-explained-2ed9627a61ff
#
# x and y vals
x <- 19.036236263
y <- 47.02345234657234


# precision
precision = 6

# the number of bits required for lat and long
nbits <- (ceiling(precision/2) * 5)

# instantiate search vectors
xvals <- c(-180, 0, 180)
yvals <- c(-90, 0, 90)

# instantiate integer vectors to hold "binary"
# 32 length because traditionally we work with 32 bit floats
xbin <- integer(nbits)
ybin <- integer(nbits)


for (i in 1:nbits) {

  # handle x
  if (x >= xvals[2]) {
    xbin[i] <- 1L
    xvals[1] <- xvals[2]
  } else {
    xvals[3] <- xvals[2]
  }

  # recalcuate mid point
  xvals[2] <- (xvals[1] + xvals[3]) / 2


  if (y >= yvals[2]) {
    ybin[i] <- 1L
    # assign min to mid
    yvals[1] <- yvals[2]
  } else {
    yvals[3] <- yvals[2]
  }

  # recalcuate mid point
  yvals[2] <- (yvals[1] + yvals[3]) / 2

}


# interleave results into a 64 bit binary
u64 <- vctrs::vec_interleave(xbin, ybin)


# split the results into chunks of 5
# grabbing the first - precision elements
bits <- split(u64, ceiling(seq_along(u64) / 5))[1:precision]

base32_conversion <- function(x) {
  bit_lu <- c('0', '1', '2', '3', '4', '5', '6', '7',
              '8', '9', 'b', 'c', 'd', 'e', 'f', 'g',
              'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r',
              's', 't', 'u', 'v', 'w', 'x', 'y', 'z')

  # add 1 b/c 1 based indexing
  position <- strtoi(paste(x, collapse = ""), 2) + 1
  bit_lu[position]
}

indexes <- vapply(bits, base32_conversion, character(1))

geohash <- paste(indexes, collapse = "")
geohash
