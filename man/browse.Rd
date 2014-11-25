\name{browse}
\alias{browse}
\title{Open the Neo4j Browser}
\description{
Open the Neo4j browser.
}
\usage{
browse(graph, viewer = TRUE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{viewer}{Logical, whether to view in IDE's viewer pane.}
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
browse(graph)
}