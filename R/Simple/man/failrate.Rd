\name{failrate}
\alias{failrate}
\non_function{}
\title{ Failrates for 7 different adjuncts }
\usage{data(failrate)}
\description{
  failing percentages for 7 different teachers
}
\format{
  This data frame contains the following columns:
  \describe{
    \item{V1}{Percentage of students failing from professor 1}
    \item{V2}{Percentage of students failing from professor 2}
    \item{V3}{Percentage of students failing from professor 3}
    \item{V4}{Percentage of students failing from professor 4}
    \item{V5}{Percentage of students failing from professor 5}
    \item{V6}{Percentage of students failing from professor 6}
    \item{V7}{Percentage of students failing from professor 7}
  }
}
\details{
  Each column has failrates for a professor. That is, number of students
  failing divided by number of students
}
\examples{
data(failrate)
fr = stack(failrate)
fr = fr[!is.na(fr$values),]
oneway.test(values ~ ind,data=fr)
}
\keyword{datasets}
