# RNeo4j

An R package that allows you to easily interact with a Neo4j graph database from your R environment.


## Installation

```r
install.packages("devtools")
devtools::install_github("nicolewhite/RNeo4j")
```

## Usage

```r
library(RNeo4j)

graph = startGraph("http://localhost:7474/db/data/")

alice = createNode(graph, "Person", name="Alice")
bob = createNode(graph, "Person", name="Bob")

createRel(alice, "KNOWS", bob, since=2001)
```
