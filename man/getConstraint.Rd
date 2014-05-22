\name{getConstraint}
\alias{getConstraint}
\title{Uniqueness Constraints}
\description{
View all uniqueness constraints for a given label or for the entire graph database.
}
\usage{
getConstraint(graph, label = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which to view all uniqueness constraints.}
}
\value{
A data frame. Returns NULL if no constraints are found.
}
\details{
Supplying only a graph object as an argument returns all uniqueness constraints in the graph database.
}
\examples{
# View all uniqueness constraints on the Person node label.
getConstraint(graph, "Person")

# View all uniqueness constraints in the graph database.
getConstraint(graph)
}
\seealso{
	\code{\link{addConstraint}}, \code{\link{dropConstraint}}
}