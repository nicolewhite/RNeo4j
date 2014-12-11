\name{importSample}
\alias{importSample}
\title{Import Sample Datasets}
\description{
Populate the graph database with one of the sample datasets supplied with this package.
}
\usage{
importSample(graph, data, input = TRUE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{data}{The dataset to be imported. Accepts a string.}
  \item{input}{Whether or not confirmation (in the form of external input) from the user should be required.}
}
\details{
Datasets available include \code{tweets}, \code{dfw}, \code{caltrain} and \code{movies}. For more information on these datasets, see here: http://nicolewhite.github.io/RNeo4j/samples/
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")

importSample(graph, "tweets")

summary(graph)
getConstraint(graph)
}