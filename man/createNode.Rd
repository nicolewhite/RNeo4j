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
  \item{...}{Optional node properties in the form key = value (separated by commas).}
  
}
\value{
A node object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

# Node without properties.
mystery = createNode(graph)

# Node with properties.
alice = createNode(graph, name = "Alice", age = 23)

# Node with label and properties. Arrays can be added as properties as well.
bob = createNode(graph, "Person", name = "Bob", age = 24, kids = c("Jenny", "Larry"))

# Node with multiple labels and properties.
charles = createNode(graph, 
					 c("Person", "Student"), 
					 name = "Charles", 
					 age = 21)
}