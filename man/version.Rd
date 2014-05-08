\name{version}
\alias{version}
\title{Neo4j Version.}
\description{
Get the Neo4j version of your graph database.
}
\usage{
version(graph)
}
\arguments{
  \item{graph}{The graph object for which you want the version.}
}
\examples{
graph = StartGraph("http://localhost:7474/db/data/")
version(graph)
}