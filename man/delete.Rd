\name{delete}
\alias{delete}
\title{Delete Nodes and Relationships}
\description{
Delete node or relationship object(s) from the graph.
}
\usage{
delete(...)
}
\arguments{
  \item{...}{Node or relationship object(s) to be deleted from the graph database (separated by commas).}
}
\details{
Nodes with incoming or outgoing relationships cannot be deleted. All incoming and outgoing relationships need to be deleted before the node can be deleted.
}
\examples{
graph = startGraph("http://localhost:7474/db/data/")
clear(graph)

alice = createNode(graph, name = "Alice")
bob = createNode(graph, name = "Bob")

rel = createRel(alice, "works with", bob)

delete(rel)
delete(alice, bob)
}