\name{simple.plot.hist.and.box}
\alias{simple.plot.hist.and.box}
%- Also NEED an `\alias' for EACH other topic documented here.
\title{A function to plot both a histogram and a boxplot}
\description{
  Simple function to plot both histogram and boxplot to compare
}
\usage{
simple.plot.hist.and.box(x, ...)
}
%- maybe also `usage' for other objects documented here.
\arguments{
  \item{x}{ vector of univariate data }
  \item{\dots}{ Arguments passed to the hist function }
}
\value{
  Just prints the two graphs
}

\author{John Verzani}
\seealso{hist,boxplot,layout }

\examples{
x<-rnorm(100)
simple.plot.hist.and.box(x)
}
\keyword{ univar }% at least one, from doc/KEYWORDS
\keyword{ aplot}