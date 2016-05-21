\name{WeightData}
\alias{WeightData}
\non_function{}
\title{ Data on height, weight and age of children }
\usage{data(WeightData)}
\description{
  The \code{WeightData} data frame has 5337 rows and 5 columns.

  Data set from NHANES data that contains weight, height and age
  information of children sampled from the United States.
  
}
\format{
  This data frame contains the following columns:
  \describe{
    \item{age}{age in months of child}
    \item{weight}{weight in pounds}
    \item{height}{height in inches}
    \item{gender}{Male = 1, Female = 2}
    \item{sample.weight}{a weight to allow for adjustment to
    oversampling procedures}
  }
}
\details{
  This data set is excerpted from the NHANES III national survey.  See
  the NHANES web site for much more information about the data.
}
\source{
  NHANES III national survey conducted 1999-2001,
  http://www.cdc.gov/nchs/nhanes.htm
}
\references{
  Data is used to make growth charts.
}
\examples{
data(WeightData)
age.yrs = floor(WeightData$age/12)
boxplot(WeightData$weight ~ age.yrs)
}
\keyword{datasets}
