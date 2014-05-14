\name{delete}
\alias{delete}
\title{Deleting Nodes and Relationships}
\description{
Delete an already-existing node or relationship.
}
\usage{
delete(...)
}
\arguments{
  \item{...}{The node or relationship object(s) to be deleted from the graph database.}
}
\details{
Nodes with incoming or outgoing relationships cannot be deleted. All incoming and outgoing relationships need to be deleted before the node can be deleted.
}
\examples{
delete(alice, bob)
}