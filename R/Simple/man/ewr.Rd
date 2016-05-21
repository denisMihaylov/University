\name{ewr}
\alias{ewr}
\non_function{}
\title{ Taxi in and taxi out times at EWR (Newark) airport for 1999-2001 }
\usage{data(ewr)}
\description{
  The \code{ewr} data frame has 46 rows and 11 columns.

  Gives taxi in and taxi out times for 8 different airlines and several
  months at EWR airport.

  Airline codes are
  "AA: American Airlines"
  "AQ: Aloha Airlines"
  "AS: Alaska Airlines"
  "CO: Continental Airlines"
  "DL: Delta Airlines"
  "HP: America West Airlines"
  "NW: Northwest Airlines"
  "TW: Trans World Airlines"
  "UA: United Airlines"
  "US: US Airways"
  "WN: Southwest Airlines"
  
}
\format{
  This data frame contains the following columns:
  \describe{
    \item{Year}{a numeric vector}
    \item{Month}{a factor for months}
    \item{AA}{a numeric vector}
    \item{CO}{a numeric vector}
    \item{DL}{a numeric vector}
    \item{HP}{a numeric vector}
    \item{NW}{a numeric vector}
    \item{TW}{a numeric vector}
    \item{UA}{a numeric vector}
    \item{US}{a numeric vector}
    \item{inorout}{a factor with levels
      \code{in} and
      \code{out}
    }
  }
}
\source{
  http://www.bts.gov/oai/taxitime/html/ewrtaxi.html
}
\examples{
data(ewr)
boxplot(ewr[3:10])
}
\keyword{datasets}
