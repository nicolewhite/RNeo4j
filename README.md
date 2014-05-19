# Rneo4j

An R package that allows you to easily populate a Neo4j graph database from your R environment. For now, it is ideal for prototyping smaller datasets. This package is also useful if you are looking to frequently pull Cypher query results into R data frames for analysis or plotting.

Compatible with Neo4j >= 2.0.

# Installation

## Install Neo4j

* [Windows](http://docs.neo4j.org/chunked/stable/server-installation.html#windows-install)
* [Mac OSX](http://docs.neo4j.org/chunked/stable/server-installation.html#osx-install)
* [Linux](http://docs.neo4j.org/chunked/stable/server-installation.html#linux-install)

## Install Rneo4j

```
install.packages("devtools")
devtools::install_github("nicolewhite/Rneo4j")
```

# Example
```
library(Rneo4j)

graph = startGraph("http://localhost:7474/db/data/")

graph$version
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

# View node properties with node$property.
mugshots$location

# [1] "Downtown"

# Add uniqueness constraints so that Person nodes are unique by name and Bar nodes are unique by name.
addConstraint(graph, "Person", "name")
addConstraint(graph, "Bar", "name")

# View all constraints in the graph.
getConstraint(graph)

# 	property_keys  label       type
# 1          name Person UNIQUENESS
# 2          name    Bar UNIQUENESS

# Find Cheer Up Charlie's and assign it to 'charlies':
charlies = getNodeByIndex(graph, "Bar", name = "Cheer Up Charlie's")

# Create relationships.
createRel(nicole, "DRINKS_AT", mugshots, on = "Fridays")
createRel(nicole, "DRINKS_AT", parlor, on = "Saturdays")
rel = createRel(nicole, "DRINKS_AT", charlies, on = "Everyday")

# View relationship properties with relationship$property.
rel$on

# [1] "Everyday"

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
# $name
# [1] "Nicole"
# 
# $hair
# [1] "blonde"
# 
# $eyes
# [1] "green"
```

## Neo4j Browser View

![Neo4j Browser](http://i.imgur.com/P49bwa4.png)