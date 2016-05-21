\name{emissions}
\alias{emissions}
\non_function{}
\title{ CO2 emissions data and Gross Domestic product for 26 countries}
\usage{data(emissions)}
\description{
The \code{emissions} data frame has 26 rows and 3 columns.

Data set for 1999

lists GDP, GDP/capita and CO2 emissions. 
}
\format{
  This data frame contains the following columns:
  \describe{
    \item{GDP}{a numeric vector}
    \item{perCapita}{a numeric vector}
    \item{CO2}{a numeric vector}
  }
}
\source{
  www.grida.no for CO2,
  www.mrdowling.com for GDP.

  Prompted by a plot appearing in a June 2001 issue of the NY Times.

}
\examples{
data(emissions)
plot(emissions)
}
\keyword{datasets}
