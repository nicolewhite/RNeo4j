\name{createRel}
\alias{createRel}
\title{Create Relationships}
\description{
Create a relationship between two nodes while simultaneously setting properties on the relationship.
}
\usage{
createRel(fromNode, type, toNode, ...)
}
\arguments{
  \item{fromNode}{The node object from which the relationship will be outgoing.}
  \item{type}{The type of relationship. Accepts a string (see details).}
  \item{toNode}{The node object to which the relationship will be incoming.}
  \item{...}{Optional relationship properties.}
}
\value{
A relationship object.
}
\details{
The string supplied for the \code{type} argument will be converted to uppercase and all spaces will be replaced with underscores. That is,

\code{createRel(alice, "works with", bob)}

is equivalent to

\code{createRel(alice, "WORKS_WITH", bob)}.
}
\examples{
rel = createRel(alice, "KNOWS", bob, since = 2000, through = "Work")
}
\seealso{
\code{\link{getStart}}, \code{\link{getEnd}}
}