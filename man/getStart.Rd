\name{getStart}
\alias{getStart}
\title{Retrieve Nodes from Relationships}
\description{
Retrieve the starting node from a relationship object. This is the node for which the relationship is outgoing.
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
\seealso{
	\code{\link{getEnd}}
}