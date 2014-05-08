\name{delete}
\alias{delete}
\title{Deleting Nodes and Relationships.}
\description{
Delete an already-existing node or relationship.
}
\usage{
delete(object)
}
\arguments{
  \item{object}{The node or relationship object to be deleted from the graph database.}
}
\details{
Nodes with incoming or outgoing relationships cannot be deleted. All incoming and outgoing relationships need to be deleted before the node can be deleted.
}
\examples{
delete(alice)
}