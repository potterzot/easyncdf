#' easyncdf is a collection of data processing verbs for working with NetCDF files.
#'
#' @author Nicholas Potter
#' @name easyncdf
#' @docType package
NULL

#' Read a ncdf4 file or connection and return a tidy data set.
#'
#' @import ncdf4
#' @export
#'
#' @param f a NetCDF filename or connection.
#' @param filter a list of statements that evaluate to TRUE/FALSE.
#' @param variables a list of variable names to return.
#' @param tidy whether to return a tidy data.frame or raw results.
#' @param ... additional parameters passed to \code{nc_open()}.
#' @return a tidy data.frame.
read_ncdf4 <- function(f, filter, variables, tidy = TRUE, ...) {
  if(missing(filter))
  con <- nc_open(f, ...)
  start_idx <- rep(1, con$ndims)
  count_idx <- sapply(con$dim, function(d) d$len)
  dim_grid <- sapply(con$dim, function(d) d$vals)
  vars <-
}


#' Summarize a ncdf4 file or connection.
#'
#' @import ncdf4
#' @export
#'
#' @param f a NetCDF filename or connection.
#' @return a table summarizing the NetCDF file.
summary.ncdf4 <- function(f) {
  con <- ifelse(typeof(f) == "character", nc_open(f), f)

  dnames <- names(con$dim)
  list(
    dimensions
  )
}

filter <- function(f) UseMethod("filter")
#' Filter data based on dimension values.
#'
#' @export
#'
#' @param .data a NetCDF filename or connection.
filter.ncdf4 <- function(.data, ...) {
  con <- ifelse(typeof(.data) == "character", nc_open(.data), .data)

  dnames <- names(con$dim)
  list(
    dimensions
  )

  if(typeof(.data) == "character") nc_close(con)
}


#' Get the names and ranges of dimensions in a NetCDF file or connection.
#'
#' @export
#' @param f either a string indicating a NetCDF file or a ncdf4 connection
dimensions <- function(f) {
  # Open the file and get the dimensions
  con <- ifelse(typeof(f) == "character", nc_open(f), f)
  dims <- names(con$dim)

  # Close the connection if a filename was provided
  if(typeof(f) == "character") nc_close(con)

  dims
}


#' Get the names of variables in a NetCDF file or connection.
#'
#' @export
#' @param f either a string indicating a NetCDF file or a ncdf4 connection
variables <- function(f) {
  # Open the file and get the dimensions
  con <- ifelse(typeof(f) == "character", nc_open(f), f)
  vars <- names(con$var)
  # Close the connection if a filename was provided
  if(typeof(f) == "character") nc_close(con)

  vars
}
