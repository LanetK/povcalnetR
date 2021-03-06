% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/povcalnet_wb.R
\name{povcalnet_wb}
\alias{povcalnet_wb}
\title{povcalnet_wb
Returns the official WB regional estimates}
\usage{
povcalnet_wb(
  povline = NULL,
  popshare = NULL,
  year = "all",
  server = NULL,
  format = "csv"
)
}
\arguments{
\item{povline}{numeric: poverty line (in 2011 PPP-adjusted USD) to
calculate poverty measures}

\item{popshare}{numeric: Share of population to calculate poverty line}

\item{year}{numeric:  list of years, or `all`.}

\item{server}{character: Key for API root URL. For testing purposes only, should not be
changed for 99 percent of users.}

\item{format}{character: Response format to be requested from the API:
`csv` or `json`}
}
\value{
data.frame
}
\description{
povcalnet_wb
Returns the official WB regional estimates
}
\examples{
\donttest{
povcalnet_wb(year = 2015)
}
}
