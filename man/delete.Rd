\name{delete}
\alias{delete}
\title{Delete Nodes and Relationships}
\description{
Delete node or relationship object(s).
}
\usage{
delete(...)
}
\arguments{
  \item{...}{The node or relationship object(s) to be deleted from the graph database (separated by commas).}
}
\details{
Nodes with incoming or outgoing relationships cannot be deleted. All incoming and outgoing relationships need to be deleted before the node can be deleted.
}
\examples{
delete(rel)
delete(alice, bob)
}