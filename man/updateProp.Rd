\name{updateProp}
\alias{updateProp}
\title{Updating Node and Relationship Properties.}
\description{
For an already-created node or relationship object, update its properties. You can override existing properties and add new properties.
}
\usage{
updateProp(object, prop)
}
\arguments{
  \item{object}{The object for which you want to update the properties. Can be either a node object or a relationship object.}
  \item{prop}{The key = value pairs of property updates.}
}
\value{
Node or relationship object.
}
\examples{
alice = updateProp(alice, age = 24, eyes = "green")
rel = updateProp(rel, since = 2001, through = "School")
}