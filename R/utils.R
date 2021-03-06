# Helpers
#----------------------------------------------------------
#   URL related functions
#----------------------------------------------------------

pt_geturl <- function(server = NULL) {
  if (is.null(server)) {
    url <-  "http://iresearch.worldbank.org"
  } else if (tolower(server)  %in%  c("int", "testing", "ar") ) {
    url <- Sys.getenv("pcn_svr")
  } else {
    warning("server not available. Default will be used")
    url <-  "http://iresearch.worldbank.org"
  }

  return(url)
}

api_handle <- function(server = NULL) {
  if (is.null(server)) {
    handle <- "povcalnet/povcalnetapi.ashx"
  } else{
    server <- tolower(server)
    if (length(server) > 1) {
      sm <- paste("`server` should be length 1, not", length(server))
      stop(sm)
    }

    if (server == "int") {

      handle <- Sys.getenv("pcn_svr_in")

    } else if (server == "testing") {

      handle <- Sys.getenv("pcn_svr_ts")

    } else if (server == "ar") {

      handle <- Sys.getenv("pcn_svr_ar")

    } else {
      stop("the server key specified does not have an API root URL associated")
    }

    if (handle == "") {
      warning("You don't have access to internal API roots. Default url will be used")
      handle <- "povcalnet/povcalnetapi.ashx"
    }
  }

  return(handle)
}

#----------------------------------------------------------
#   Data formatting
#----------------------------------------------------------

format_data <- function(x, aggregate, format) {

  if (aggregate == FALSE){
    x <- format_data_cl(x = x,
                        format = format)
  } else {
    x <- format_data_aggregate(x = x)
  }
  return(x)
}



format_data_cl <- function(x, format) {

  if (format == "csv") {
    x <- format_data_cl_csv(x)
    # rename data_type to be more explicit
    x$datatype <- datatype_lkup[x$datatype]
  } else {
    x <- format_data_cl_json(x)
  }



  if (nrow(x) > 0) {
    # replace invalid values to missing
    rvars <- c("median", "polarization", "gini", "mld",
               stringr::str_subset(names(x), "^decile"))

    x <- naniar::replace_with_na_at(data = x,
                                    .vars = rvars,
                                    condition = ~.x  %in% c(-1, 0))
  }

  return(tibble::as_tibble(x))
}

format_data_cl_csv <- function(x) {
  # CHECK
  assertthat::assert_that(
    all.equal(names(x), povcal_col_names)
  )

  x <- dplyr::select(x,
                     "countrycode"    = "CountryCode",
                     "countryname"    = "CountryName",
                     "regioncode"     = "RegionCode",
                     "coveragetype"   = "CoverageType",
                     "year"           = "RequestYear",
                     "datayear"       = "DataYear",
                     "datatype"       = "DataType",
                     "isinterpolated" = "isInterpolated",
                     "usemicrodata"   = "useMicroData",
                     "ppp"            = "PPP",
                     "povertyline"    = "PovertyLine",
                     "mean"           = "Mean",
                     "headcount"      = "HeadCount",
                     "povertygap"     = "PovGap",
                     "povertygapsq"   = "PovGapSqr",
                     "watts"          = "Watts",
                     "gini"           = "Gini",
                     "median"         = "Median",
                     "mld"            = "pr.mld",
                     "polarization"   = "Polarization",
                     "population"     = "ReqYearPopulation",
                     "decile1"        = "Decile1",
                     "decile2"        = "Decile2",
                     "decile3"        = "Decile3",
                     "decile4"        = "Decile4",
                     "decile5"        = "Decile5",
                     "decile6"        = "Decile6",
                     "decile7"        = "Decile7",
                     "decile8"        = "Decile8",
                     "decile9"        = "Decile9",
                     "decile10"       = "Decile10"
  )

  return(x)
}

#' format_data_cl_json
#'
#' @param x data.frame: API response
#'
#' @return data.frame
#'
format_data_cl_json <- function(x) {
  # CHECK
  assertthat::assert_that(
    all.equal(names(x), povcal_col_names_json)
  )

  x <- dplyr::mutate(x,
      decile1 = purrr::map(Decile, ~ .x[1]),
      decile2 = purrr::map(Decile, ~ .x[2]),
      decile3 = purrr::map(Decile, ~ .x[3]),
      decile4 = purrr::map(Decile, ~ .x[4]),
      decile5 = purrr::map(Decile, ~ .x[5]),
      decile6 = purrr::map(Decile, ~ .x[6]),
      decile7 = purrr::map(Decile, ~ .x[7]),
      decile8 = purrr::map(Decile, ~ .x[8]),
      decile9 = purrr::map(Decile, ~ .x[9]),
      decile10 = purrr::map(Decile, ~ .x[10])
    )
  x[["Decile"]] <- NULL

  x <- dplyr::select(x,
                     "countrycode"    = "CountryCode",
                     "countryname"    = "CountryName",
                     "regioncode"     = "RegionCode",
                     "coveragetype"   = "CoverageType",
                     "year"           = "RequestYear",
                     "datayear"       = "DataYear",
                     "datatype"       = "DataType",
                     "isinterpolated" = "interpolated",
                     "usemicrodata"   = "useMicroData",
                     "ppp"            = "PPP",
                     "povertyline"    = "PovertyLine",
                     "mean"           = "Mean",
                     "headcount"      = "HC",
                     "povertygap"     = "pg",
                     "povertygapsq"   = "PovGapSqr",
                     "watts"          = "Watts",
                     "gini"           = "Gini",
                     "median"         = "Median",
                     "mld"            = "pr.mld",
                     "polarization"   = "Polarization",
                     "population"     = "ReqYearPopulation",
                     "decile1"        = "decile1",
                     "decile2"        = "decile2",
                     "decile3"        = "decile3",
                     "decile4"        = "decile4",
                     "decile5"        = "decile5",
                     "decile6"        = "decile6",
                     "decile7"        = "decile7",
                     "decile8"        = "decile8",
                     "decile9"        = "decile9",
                     "decile10"       = "decile10"
  )

  x$datatype <- tolower(x$datatype)

  return(x)
}



format_data_aggregate <- function(x) {
  # CHECK
  assertthat::assert_that(
    all.equal(names(x), povcal_col_names_agg)
  )

  x <- dplyr::select(x,
                     "regiontitle"  = "regionTitle",
                     "regioncode"   = "regionCID",
                     "year"         = "requestYear",
                     "povertyline"  = "povertyLine",
                     "mean"         = "mean",
                     "headcount"    = "hc",
                     "povertygap"   = "pg",
                     "povertygapsq" = "p2",
                     "population"   = "population"
  )

  return(tibble::as_tibble(x))
}

assign_country <- function(country) {

  if (length(country) == 1 & all("all" %in% country)) {
    country <- all_countries
  } else {
    country
  }
}


assign_coverage <- function(coverage, country) {

  if (coverage == "all") {
    country        <- unname(all_coverage[names(all_coverage) %in% country])

  } else if (coverage == "national") {
    coverage_codes <- national_coverage_lkup[country]
    coverage_codes <- coverage_codes[!is.na(coverage_codes)]
    country        <- paste(names(coverage_codes), coverage_codes, sep = "_")

  } else {
    coverage       <- unname(coverage_lkup[coverage])
    country        <- paste(country, coverage, sep = "_")
  }

  return(country)
}


handle_empty_response <- function(x, aggregate) {
  if (aggregate == FALSE) {
    x           <- data.frame(matrix(ncol = length(povcal_col_names), nrow = 0))
    colnames(x) <- povcal_col_names

  } else  {
    x           <- data.frame(matrix(ncol = length(povcal_col_names_agg), nrow = 0))
    colnames(x) <- povcal_col_names_agg
  }
  return(x)
}

