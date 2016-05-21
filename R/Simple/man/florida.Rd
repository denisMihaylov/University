\name{florida}
\alias{florida}
\non_function{}
\title{ County-by-County results of year 2000 US presidential election
in Florida }
\usage{data(florida)}
\description{
The \code{florida} data frame has 67 rows and 13 columns.

Gives a county by county accounting of the US elections in the state of
Florida.  }
\format{
  This data frame contains the following columns:
  \describe{
    \item{County}{a numeric vector}
    \item{V2}{a numeric vector}
    \item{GORE}{a numeric vector}
    \item{BUSH}{a numeric vector}
    \item{BUCHANAN}{a numeric vector}
    \item{NADER}{a numeric vector}
    \item{BROWNE}{a numeric vector}
    \item{HAGELIN}{a numeric vector}
    \item{HARRIS}{a numeric vector}
    \item{MCREYNOLDS}{a numeric vector}
    \item{MOOREHEAD}{a numeric vector}
    \item{PHILLIPS}{a numeric vector}
    \item{Total}{a numeric vector}
  }
}
\source{
  Found in the excellent guide    ``Using R for Data Analysis and
  Graphics''  by John Maindonald. The data set is available from
  \url{http://room.anu.edu.au/~johnm/} 


}
\examples{
data(florida)
attach(florida)
result.lm <- lm(BUCHANAN ~ BUSH)
plot(BUSH,BUCHANAN)
abline(result.lm) ## can you find Miami-Dade coutny?
}
\keyword{datasets}
