\name{populate}
\alias{populate}
\title{Populate the Graph Database}
\description{
Populate the graph database with example datasets supplied with this package.
}
\usage{
populate(graph, data)
}
\arguments{
  \item{graph}{A graph object.}
  \item{data}{The dataset to be imported. Accepts a string.}
}
\details{
As of now, the only example dataset available is the movie dataset. This can be accessed by setting data = "movies".
}
\examples{
populate(graph, "movies")
}