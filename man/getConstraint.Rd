\name{getConstraint}
\alias{getConstraint}
\title{Uniqueness Constraints.}
\description{
Get all uniqueness constraints for a given label or for the entire graph database.
}
\usage{
getConstraint(graph, label = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{The label for which you want to see all uniqueness constraints.}
}
\value{
A data frame. Returns NULL if no constraints are found.
}
\details{
Supplying only a graph object as an argument returns all uniqueness constraints in the graph database.
}
\examples{
# View all uniqueness constraints on Person nodes.
getIndex(graph, "Person")

# View all uniqueness constraints in the graph.
getIndex(graph)
}