\name{babies}
\alias{babies}
\non_function{}
\title{Data set with Mothers and Babies data from Child Health and
Development Study  }
\usage{data(babies)}
\description{
The \code{babies} data frame has 1236 rows and 7 columns.

}
\format{
  This data frame contains the following columns:
  \describe{
    \item{bwt}{a numeric vector}
    \item{gestation}{a numeric vector}
    \item{parity}{a numeric vector}
    \item{age}{a numeric vector}
    \item{height}{a numeric vector}
    \item{weight}{a numeric vector}
    \item{smoke}{a numeric vector}
  }
}
\details{
See \url{http://www.stat.Berkeley.EDU/users/statlabs/labs.html} for a thorough 
description.

}
\source{
Borrowed from Nolan and Speeds StatLabs
datasets. \url{http://www.stat.Berkeley.EDU/users/statlabs/}
}
\examples{
data(babies)
pairs(babies)
}
\keyword{datasets}
