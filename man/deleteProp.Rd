\name{deleteProp}
\alias{deleteProp}
\title{Deleting Node and Relationship Properties.}
\description{
For a node or relationship object, delete the named properties or delete all properties.
}
\usage{
deleteProp(object, ..., all = FALSE)
}
\arguments{
  \item{object}{The node or relationship object for which the named properties will be deleted.}
  \item{...}{The properties to be deleted. Accepts strings.}
  \item{all}{Set this to TRUE if you want to delete all properties on the node or relationship.}
}
\value{
A node or relationship object.
}
\examples{
# Delete the "age" property from the Alice node.
alice = deleteProp(alice, "age")

# Delete the "name" and "age" properties from the Bob node.
bob = deleteProp(bob, "name", "age")

# Delete all properties from the Charles node.
charles = deleteProp(charles, all = TRUE)
}

