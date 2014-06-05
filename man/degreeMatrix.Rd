\name{degreeMatrix}
\alias{degreeMatrix}
\title{Degree Matrices}
\description{
Get a degree matrix for a set of nodes with a specified label, identified by their unique property key, and where degree is defined by the relationship type given. The degree matrix can be direction-agnostic or directed.
}
\usage{
degreeMatrix(graph, label, key, type, direction = character())
}
\arguments{
  \item{graph}{A graph object.}
  \item{label}{A node label. Accepts a string.}
  \item{key}{A unique property key by which the nodes will be identified in the degree matrix's rows and columns. Accepts a string.}
  \item{type}{A relationship type by which the nodes are tested for degree centrality. Accepts a string.}
  \item{direction}{An optional direction specifying whether the degree matrix should be direction-agnostic or directed. Accepts a string, either "incoming" or "outgoing".}
}
\details{
If a direction is not supplied, the \code{(i, j)} entry of the degree matrix captures how many relationships of type \code{type} are attached to node \code{i} regardless of direction. If \code{direction = "incoming"}, the \code{(i, j)} entry of the degree matrix captures how many incoming relationships of type \code{type} are attached to node \code{i}. If \code{direction = "outgoing"}, the \code{(i, j)} entry of the degree matrix captures how many outgoing relationships of type \code{type} are attached to node \code{i}.

Degrees are returned as a matrix so that one can easily calculate a Laplacian matrix, \eqn{L}, which can be found by \eqn{L = D - A}, where \eqn{D} is a degree matrix and \eqn{A} is an adjacency matrix.
}
\value{
A square, diagonal degree matrix.
}
\seealso{
\code{\link{adjacencyMatrix}}
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

# Get an in-degree matrix.
in_deg = degreeMatrix(graph,
                      label = "Person",
                      key = "name",
                      type = "KNOWS",
                      direction = "incoming")
                      
#         Alex Bob Charles Debby Elaine Forrest
# Alex       1   0       0     0      0       0
# Bob        0   1       0     0      0       0
# Charles    0   0       1     0      0       0
# Debby      0   0       0     2      0       0
# Elaine     0   0       0     0      2       0
# Forrest    0   0       0     0      0       1

# Get an out-degree matrix.
out_deg = degreeMatrix(graph,
                       label = "Person",
                       key = "name",
                       type = "KNOWS",
                       direction = "outgoing")
                       
#         Alex Bob Charles Debby Elaine Forrest
# Alex       2   0       0     0      0       0
# Bob        0   2       0     0      0       0
# Charles    0   0       1     0      0       0
# Debby      0   0       0     2      0       0
# Elaine     0   0       0     0      1       0
# Forrest    0   0       0     0      0       0

# Get a direction-agnostic degree matrix.

deg = degreeMatrix(graph,
                   label = "Person",
                   key = "name",
                   type = "KNOWS")
                   
#         Alex Bob Charles Debby Elaine Forrest
# Alex       3   0       0     0      0       0
# Bob        0   3       0     0      0       0
# Charles    0   0       2     0      0       0
# Debby      0   0       0     4      0       0
# Elaine     0   0       0     0      3       0
# Forrest    0   0       0     0      0       1                       
}

