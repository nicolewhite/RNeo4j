\name{createRel}
\alias{createRel}
\title{Creating Relationships.}
\description{
Create a relationship between two nodes while simultaneously setting properties on the relationship.
}
\usage{
createRel(fromNode, type, toNode, ...)
}
\arguments{
  \item{fromNode}{The node object from which the relationship will be outgoing.}
  \item{type}{The type of relationship. Accepts a string.}
  \item{toNode}{The node object to which the relationship will be incoming.}
  \item{props}{Optional relationship properties.}
}
\value{
A relationship object.
}
\examples{
rel = createRel(alice, "KNOWS", bob, since = 2000, through = "Work")
}