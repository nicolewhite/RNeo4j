\name{getLabeledNodes}
\alias{getLabeledNodes}
\title{Retrieve Nodes by Label and Property}
\description{
Retrieve nodes from the graph with the specified label and optional key = value pair.
}
\usage{
getLabeledNodes(graph, .label, ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{.label}{A node label. Accepts a string.}
  \item{...}{An optional key = value pair by which to filter the results. Only accepts one key = value pair.}
}
\value{
A list of node objects. Returns NULL if no nodes are found.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

createNode(graph, "School", name = "University of Texas at Austin")
createNode(graph, "School", name = "Louisiana State University")

createNode(graph, "Person", name = "Nicole", status = "Employed")
createNode(graph, "Person", name = "Drew", status = "Employed")
createNode(graph, "Person", name = "Aaron", status = "Unemployed")

schools = getLabeledNodes(graph, "School")

sapply(schools, function(s) s$name)

employed_people = getLabeledNodes(graph, "Person", status = "Employed")

sapply(employed_people, function(p) p$name)
}
\seealso{
\code{\link{getUniqueNode}}
}