\name{adjacencyMatrix}
\alias{adjacencyMatrix}
\title{Adjacency Matrices}
\description{
Get an adjacency matrix for a set of nodes with a specified label, identified by their unique property key, and where adjacency is defined by the relationship type given. The adjacency matrix can be direction-agnostic or directed.
}
\usage{
adjacencyMatrix(graph, label, key, type, direction = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label. Accepts a string.}
  \item{key}{A unique property key by which the nodes will be identified in the adjacency matrix's rows and columns. Accepts a string.}
  \item{type}{A relationship type by which the nodes are tested for adjacency. Accepts a string.}
  \item{direction}{An optional direction specifying whether the adjacency matrix should be direction-agnostic or directed. Accepts a string, either "incoming" or "outgoing".}
}
\details{
If a direction is not supplied, the \code{(i, j)} entry of the adjacency matrix will capture whether or not a relationship of type \code{type} exists between node \code{i} and node \code{j} regardless of direction. If \code{direction = "incoming"}, the \code{(i, j)} entry of the adjacency matrix will capture whether or not there is an incoming relationship of type \code{type} to node \code{i} from node \code{j}. If \code{direction = "outgoing"}, the \code{(i, j)} entry of the adjacency matrix will capture whether or not there is an outgoing relationship of type \code{type} from node \code{i} to node \code{j}.

An adjacency matrix with \code{direction = "incoming"} is equal to the transpose of an adjacency matrix with \code{direction = "outgoing"} and vice versa.
}
\value{
A square adjacency matrix. If a direction is not supplied, the matrix will be symmetric. Otherwise, it will be asymmetric.
}
\seealso{
\code{\link{degreeMatrix}}
}
\examples{
addConstraint(graph, "Person", "name")

alice = createNode(graph, "Person", name = "Alex")
bob = createNode(graph, "Person", name = "Bob")
charles = createNode(graph, "Person", name = "Charles")
debby = createNode(graph, "Person", name = "Debby")
elaine = createNode(graph, "Person", name = "Elaine")
forrest = createNode(graph, "Person", name = "Forrest")

createRel(alice, "KNOWS", bob)
createRel(alice, "KNOWS", elaine)
createRel(bob, "KNOWS", elaine)
createRel(bob, "KNOWS", charles)
createRel(charles, "KNOWS", debby)
createRel(debby, "KNOWS", alice)
createRel(debby, "KNOWS", forrest)
createRel(elaine, "KNOWS", debby)

# Get a directed adjacency matrix of outgoing "KNOWS" relationships.
out_adj = adjacencyMatrix(graph, 
                          label = "Person",
                          key = "name",
                          type = "KNOWS",
                          direction = "outgoing")
                          
out_adj

#         Alex Bob Charles Debby Elaine Forrest
# Alex       0   1       0     0      1       0
# Bob        0   0       1     0      1       0
# Charles    0   0       0     1      0       0
# Debby      1   0       0     0      0       1
# Elaine     0   0       0     1      0       0
# Forrest    0   0       0     0      0       0

# Get a directed adjacency matrix of incoming "KNOWS" relationships.
in_adj = adjacencyMatrix(graph, 
                         label = "Person",
                         key = "name",
                         type = "KNOWS",
                         direction = "incoming")
                         
in_adj

#         Alex Bob Charles Debby Elaine Forrest
# Alex       0   0       0     1      0       0
# Bob        1   0       0     0      0       0
# Charles    0   1       0     0      0       0
# Debby      0   0       1     0      1       0
# Elaine     1   1       0     0      0       0
# Forrest    0   0       0     1      0       0

# The incoming relationship matrix is equal to the transpose of the 
# outgoing adjacency matrix and vice versa.
identical(in_adj, t(out_adj))

# [1] TRUE

identical(out_adj, t(in_adj))

# [1] TRUE

# Get a direction-agnostic adjacency matrix of "KNOWS" relationships.
adj = adjacencyMatrix(graph, 
                      label = "Person",
                      key = "name",
                      type = "KNOWS")
                      
adj

#         Alex Bob Charles Debby Elaine Forrest
# Alex       0   1       0     1      1       0
# Bob        1   0       1     0      1       0
# Charles    0   1       0     1      0       0
# Debby      1   0       1     0      1       1
# Elaine     1   1       0     1      0       0
# Forrest    0   0       0     1      0       0
}
