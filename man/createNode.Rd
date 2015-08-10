\name{createNode}
\alias{createNode}
\title{Create Nodes}
\description{
Create a node in the graph with the given label and properties.
}
\usage{
createNode(graph, .label = character(), ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{.label}{Optional node label(s). Accepts a string or vector of strings.}
  \item{...}{Optional node properties in the form key = value.}
}
\details{
Parameters can be passed in individually or as a list, e.g.

\code{createNode(graph, "Person", key1=value1, key2=value2)}

or

\code{createNode(graph, "Person", list(key1=value1, key2=value2))}
}
\value{
A node object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

bob = createNode(graph, "Person", name = "Bob", age = 24, kids = c("Jenny", "Larry"))

charles = createNode(graph, c("Person", "Student"), name = "Charles", age = 21)
					 
props = list(name="David", age = 26)
david = createNode(graph, "Person", props)
}