library(easyncdf)
library(ncdf4)
context("Test Package")

filename <- "tests/data/test.nc4"
con <- nc_open(filename)

test_that("read_ncdf() reads data", {
  bounds <- list(
    "time" = c(0,12),
    "ens" = c(1,3),
    "lat" = c(42, 45),
    "lon" = c(233, 235),
    "isobaric1" = c(10000, 30000),
    "time2" = c(18,24),
    "height_above_ground" = c(2,2)
  )
  v <- "Total_precipitation_surface_6_Hour_Accumulation_ens"
  d <- read_ncdf(filename, variables = v)
})

