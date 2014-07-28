\name{getIndex}
\alias{getIndex}
\title{Indexes}
\description{
Get all indexes for a given label or for the entire graph database.
}
\usage{
getIndex(graph, label = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label for which to view all indexes. Accepts a string.}
}
\value{
A data frame. Returns NULL if no indexes are found.
}
\details{
Supplying only a graph object as an argument returns all indexes in the graph database.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "Person", name = "Nicole", status = "Employed")
createNode(graph, "Person", name = "Drew", status = "Employed")
createNode(graph, "Person", name = "Aaron", status = "Unemployed")

createNode(graph, "School", name = "University of Texas at Austin", type = "Public")
createNode(graph, "School", name = "Louisiana State University", type = "Public")

addIndex(graph, "Person", "status")
addIndex(graph, "School", "type")

# Get all indexes on the Person node label.
getIndex(graph, "Person")

# Get all indexes in the graph database.
getIndex(graph)
}
\seealso{
	\code{\link{addIndex}}, \code{\link{dropIndex}}
}