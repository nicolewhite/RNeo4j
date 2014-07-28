\name{deleteProp}
\alias{deleteProp}
\title{Delete Node and Relationship Properties}
\description{
For a node or relationship object, delete the named properties or delete all properties.
}
\usage{
deleteProp(object, ..., all = FALSE)
}
\arguments{
  \item{object}{A node or relationship object for which the named properties will be deleted.}
  \item{...}{The properties to be deleted. Accepts a single string or strings separated by commas.}
  \item{all}{Set to TRUE to delete all properties on the node or relationship object.}
}
\value{
A node or relationship object.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, "Person", name = "Alice", age = 23, status = "Married")
bob = createNode(graph, "Person", name = "Bob", age = 22, status = "Married")
charles = createNode(graph, "Person", name = "Charles", age = 25, status = "Unmarried")

# Delete the "age" property from the alice node.
alice = deleteProp(alice, "age")

# Delete the "name" and "age" properties from the Bob node.
bob = deleteProp(bob, "name", "age")

# Delete all properties from the Charles node.
charles = deleteProp(charles, all = TRUE)
}
\seealso{
	\code{\link{updateProp}}
}

