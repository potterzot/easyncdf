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
#' @param bounds a named list of dimension bounds. Returned values are inclusive
#'   of bounds.
#' @param variables a list of variable names to return.
#' @param ... additional parameters passed to \code{nc_open()}.
#' @param warn_cells the number of returned cells (rows X columns) at which to
#'   fail if \code{force} is not set to TRUE.
#' @param force force fetching data even if it will exceed 1 million records.
#' @return a tidy data.frame.
read_ncdf <- function(f, bounds, variables, ...,
                      warn_cells = 1e7, force = FALSE) {
  if(missing(bounds)) bounds <- list()

  ### Open the file or set up the connection
  con <- if(is.character("character")) nc_open(f, ...) else f

  ### If no variables are specified, then read them all
  if(missing(variables)) variables <- names(con$var)
  stopifnot(all(sapply(variables, function(v) v %in% names(con$var))))

  ### If no bounds are specified, return all dimension indices
  dim_idx <- lapply(names(con$dim), function(d) {
    bd <- bounds[[d]]    # the bounding box dimension
    cd <- con$dim[[d]]   # the ncdf dimension
    cdv <- cd$vals       # ncdf dimension values
    if(d %in% names(bounds)) {
      b <- c(which(cdv == min(cdv[which(cdv >= bd[1])])),
             which(cdv == max(cdv[which(cdv <= bd[2])])))
    } else {
      b <- c(1, cd$len)
    }

    # Some indices count down... (ughh)
    if(b[1] > b[2]) b <- c(b[2], b[1])
    b
  })
  names(dim_idx) <- names(con$dim)

  ### Set the start and count indices based on the bounds.
  start_idx <- sapply(dim_idx, function(d) { d[[1]] })
  count_idx <- sapply(1:length(dim_idx), function(i) {
    dim_idx[[i]][2] - dim_idx[[i]][1] + 1
  })

  ### Create a data.frame of all possible dimension combinations.
  ncells <- prod(count_idx)*length(variables)
  if(!force & ncells > warn_cells) {
    stop(paste0("Number of returned records will exceed ", warn_rows, ". Adjust
                parameters to allow more records or set 'force = TRUE' to skip
                this check."))
  }
  dim_vals <- lapply(names(con$dim), function(d) {
    con$dim[[d]]$vals[dim_idx[[d]][1]:dim_idx[[d]][2]]
  })
  dim_grid <- expand.grid(dim_vals)

  ### Get the data for each variable.
  # Variables can have different dimensions so first we select just the
  # dimensions that apply and in the order they apply, then we pull the data
  # for that variable.
  d <- lapply(variables, function(v) {
    cv <- con$var[[v]]
    dims <- names(con$dim)[cv$dimids + 1]
    starts <- start_idx[cv$dimids + 1]
    counts <- count_idx[cv$dimids + 1]
    dim_grid <- expand.grid(lapply(dims, function(d) {
      con$dim[[d]]$vals[dim_idx[[d]][1]:dim_idx[[d]][2]]
    }))

    # Return the variable with the dimensions.
    tmpdf <- cbind(dim_grid,
          matrix(ncvar_get(con, v, start = starts, count = counts), ncol = 1)
    )
    names(tmpdf) <- c(dims, v)
    tmpdf
  })
  d
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
