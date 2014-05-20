\name{startGraph}
\alias{startGraph}
\title{Connect to the Database}
\description{
Connect to the graph database.
}
\usage{
startGraph(url)
}
\arguments{
  \item{url}{The URL of the graph database. Accepts a string.}
}
\value{
A graph object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
}

