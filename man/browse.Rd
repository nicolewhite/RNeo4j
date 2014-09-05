\name{browse}
\alias{browse}
\title{Open the Neo4j Browser}
\description{
Open the Neo4j browser in the default web browser.
}
\usage{
browse(graph)
}
\arguments{
  \item{graph}{A graph object.}
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
browse(graph)
}