<!-- README.md is generated from README.Rmd. Please edit that file -->
[![ORCiD](https://img.shields.io/badge/ORCiD-0000--0002--3410--3732-green.svg)](http://orcid.org/0000-0002-3410-3732)
[![Licence](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)

[![Last-changedate](https://img.shields.io/badge/last%20change-2018--03--26-brightgreen.svg)](https://github.com/potterzot/easyncdf/commits/master)
[![minimal R
version](https://img.shields.io/badge/R%3E%3D-3.0.3-brightgreen.svg)](https://cran.r-project.org/)
[![Travis-CI Build
Status](https://travis-ci.org/potterzot/easyncdf.png?branch=master)](https://travis-ci.org/potterzot/easyncdf)
[![Coverage
Status](https://coveralls.io/repos/github/potterzot/easyncdf/badge.svg?branch=master)](https://coveralls.io/github/potterzot/easyncdf?branch=master)

easyncdf
========

easyncdf is an `R` package intended to make it easier to work with
NetCDF files in `R`. It builds on the functionality in ncdf4 and extends
dplyr syntax like `filter` to facilitate familiar reading (and
potentially writing) of data from/to NetCDF files.

Installing
----------

Install like any R package from github:

    library(devtools)
    install_github('potterzot/easyncdf')

Usage
-----

If your NetCDF file is small enough, you can read the entire thing into
a list of tidy data.frames with `read_ncdf(<filename>)`. For larger
files or specific variables you can set the bounds of any dimension and
the variables you’d like to read in.

Testing
-------

A test dataset is included in [tests/data/](tests/data). A simple test
is to try to read that data into `R` with
`read_ncdf("tests/data/test.nc4")`. You can also play around with
defining bounds and variables as (very lightly at the moment) done in
[tests/testthat/test\_easyncdf.R](tests/testthat/test_easyncdf.R).

License
-------

[MIT License](https://opensource.org/licenses/MIT), 2018, Nicholas A
Potter
