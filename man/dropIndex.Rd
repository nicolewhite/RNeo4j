\name{dropIndex}
\alias{dropIndex}
\title{Indexes}
\description{
Drop the index(es) for a given node label and property key or for the entire graph database.
}
\usage{
dropIndex(graph, label = character(), key = character(), all = FALSE)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label for which to drop the index. Accepts a string.}
  \item{key}{A property key for which to drop the index. Accepts a string.}
  \item{all}{Set to TRUE to drop all indexes from the graph.}
}
\details{
Dropping a uniqueness constraint necessarily drops the index as well. It is unnecessary to use \code{dropIndex} if \code{\link{dropConstraint}} has already been applied to the same \code{(label, key)} pair.
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

getIndex(graph)

# Drop the index on Person nodes by the name property.
dropIndex(graph, "Person", "status")

getIndex(graph)

# Drop all indexes from the graph database.
dropIndex(graph, all = TRUE)

getIndex(graph)
}
\seealso{
	\code{\link{addIndex}}, \code{\link{getIndex}}
}