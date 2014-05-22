\name{getEnd}
\alias{getEnd}
\title{Retrieve Nodes from Relationships}
\description{
Retrieve the ending node from a relationship object. This is the node for which the relationship is incoming.
}
\usage{
getEnd(rel)
}
\arguments{
  \item{rel}{A relationship object.}
}
\value{
A node object.
}
\examples{
rel = createRel(alice, "KNOWS", bob)
end = getEnd(rel)

identical(end, bob)
# TRUE
}
\seealso{
	\code{\link{getStart}}
}