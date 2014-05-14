\name{createNode}
\alias{createNode}
\title{Creating Nodes}
\description{
Create a node in the graph with the given label and properties.
}
\usage{
createNode(graph, label = character(), ...)
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{An optional node label. Accepts a string or vector of strings.}
  \item{...}{Optional node properties.}
  
}
\value{
A node object.
}
\examples{
# Node without properties.
mystery = createNode(graph)

# Node with properties.
alice = createNode(graph, name = "Alice", age = 23)

# Node with label and properties.
bob = createNode(graph, "Person", name = "Bob", age = 24)

# Node with multiple labels and properties.
charles = createNode(graph, c("Person", "Student"), name = "Charles", age = 21)
}