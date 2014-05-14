\name{getStart}
\alias{getStart}
\title{Retrieving Nodes from a Relationship}
\description{
Retrieve the starting node of a relationship. This is the node for which the relationship is outgoing.
}
\usage{
getStart(rel)
}
\arguments{
  \item{rel}{A relationship object.}
}
\value{
A node object.
}
\examples{
rel = createRel(alice, "KNOWS", bob)
start = getStart(rel)

identical(start, alice)
# TRUE
}