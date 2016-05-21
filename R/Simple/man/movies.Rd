\name{movies}
\alias{movies}
\non_function{}
\title{ Top 25 movies for June 2001 }
\usage{data(movies)}
\description{
  The \code{movies} data frame has 26 rows and 4 columns.

  The top 25 movies for a week in June 2001. Contains weeks revenues,
  previous week  and
  total gross.
}
\format{
  This data frame contains the following columns:
  \describe{
    \item{title}{a factor with levels of movie title's}
    \item{current}{a numeric vector}
    \item{previous}{a factor which should be numeric}
    \item{gross}{a numeric vector}
  }
}
\source{
  found on \url{http://www.movieweb.com/movie/top25.html}
}
\examples{
data(movies)
hist(movies[['current']])
}
\keyword{datasets}
