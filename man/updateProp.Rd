\name{updateProp}
\alias{updateProp}
\title{Update Node and Relationship Properties}
\description{
For a node or relationship object, update its properties. Existing properties can be overridden and new properties can be added.
}
\usage{
updateProp(object, ...)
}
\arguments{
  \item{object}{A node or relationship object.}
  \item{...}{Property updates or additions in the form key = value (separated by commas).}
}
\value{
A node or relationship object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice")

# Update the age property and add an eyes property to the alice node.
alice = updateProp(alice, age = 24, eyes = "green")
}
\seealso{
	\code{\link{deleteProp}}
}