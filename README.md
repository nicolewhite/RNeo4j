# Rneo4j

An R package that allows you to easily populate a Neo4j graph database from your R environment. For now, it is ideal for prototyping smaller datasets. This package is also useful if you are looking to frequently pull Cypher query results into R data frames for analysis or plotting.

Compatible with Neo4j >= 2.0.

# Current Functionality

* Create nodes with properties.
* Create relationships (with properties) between nodes.
* Update and delete properties on already-created nodes and relationships.
* Delete nodes and relationships.
* Retrieve Cypher query results as a data frame.
* Labels.
* Indexing (for nodes only).
* Load sample datasets with `populate()`.

# TODO Functionality

In no particular order:

* Add username and password arguments to `startGraph()`.
* Enable the handling of collections in Cypher query results (maybe).
* Add indexing for relationships.
* Retrieve relationship objects with a Cypher query or by label/index.
* Add `getIn()` and `getOut()` for getting incoming and outgoing relationships on a node.
* Add batch operations. Tentatively to include `newBatch()`, `appendBatch()`, and `runBatch()`.
* Add options to `getNodeByIndex()` for "get or create unique."

# Installation

## Install Neo4j

http://www.neo4j.org/download/other_versions

## Install Rneo4j

```
install.packages("devtools")
devtools::install_github("nicolewhite/Rneo4j")
```

# Example
```
library(Rneo4j)

graph = startGraph("http://localhost:7474/db/data/")

version(graph)
# [1] "2.0.0-RC1"

# Clear the database.
clear(graph)

# Create nodes with labels and properties. I forget to assign Cheer Up Charlie's to a variable,
# but I take care of that later.
mugshots = createNode(graph, "Bar", name = "Mugshots", location = "Downtown")
parlor = createNode(graph, "Bar", name = "The Parlor", location = "Hyde Park")
createNode(graph, "Bar", name = "Cheer Up Charlie's", location = "Downtown")

# Labels can be added after creating the node.
nicole = createNode(graph, name = "Nicole", status = "Student")
addLabel(nicole, "Person")

# Index Person nodes by name and Bar nodes by name.
addIndex(graph, "Person", "name")
addIndex(graph, "Bar", "name")

# View all indices in the graph.
getIndex(graph)

# 	property_keys  label
# 1          name Person
# 2          name    Bar

# Find Cheer Up Charlie's and assign it to 'charlies':
charlies = getNodeByIndex(graph, "Bar", "name", "Cheer Up Charlie's")

# Create relationships.
createRel(nicole, "DRINKS_AT", mugshots, on = "Fridays")
createRel(nicole, "DRINKS_AT", parlor, on = "Saturdays")
createRel(nicole, "DRINKS_AT", charlies, on = "Everyday")

# Get Cypher query results as a data frame.
query  = "MATCH (p:Person {name:'Nicole'})-[d:DRINKS_AT]->(b:Bar)
		  RETURN p.name, d.on, b.name, b.location"

cypher(graph, query)

# 	p.name      d.on             b.name b.location
# 1 Nicole   Fridays           Mugshots   Downtown
# 2 Nicole Saturdays         The Parlor  Hyde Park
# 3 Nicole  Everyday Cheer Up Charlie's   Downtown

# Add more properties to a node.
nicole = updateProp(nicole, eyes = "green", hair = "blonde")

# Delete properties on a node.
nicole = deleteProp(nicole, "status")

print(nicole)

# Labels: Person
# 
#     name     hair     eyes 
# "Nicole" "blonde"  "green" 
```

## Neo4j Browser View

![Neo4j Browser](http://i.imgur.com/P49bwa4.png)

Happy graphing!