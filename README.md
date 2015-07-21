# RNeo4j

RNeo4j is Neo4j's R driver. It allows you to read and write data from / to Neo4j directly from your R environment.

## Contents

* [Install](#install)
* [Connect](#connect)
* [Nodes](#nodes)
* [Relationships](#relationships)
* [Cypher](#cypher)
* [Shortest Paths](#shortest-paths)
* [Weighted Shortest Paths](#weighted-shortest-paths)
* [Graph Algorithms](#graph-algorithms)
* [Visualizations](#visualizations)
* [Import](#import)

## <a name="#install"></a>Install


```r
install.packages("devtools")
devtools::install_github("nicolewhite/RNeo4j")
library(RNeo4j)
```



## <a name="#connect"></a>Connect


```r
graph = startGraph("http://localhost:7474/db/data/")
```



## <a name="#nodes"></a>Nodes


```r
nicole = createNode(graph, "Person", name="Nicole", age=24)
greta = createNode(graph, "Person", name="Greta", age=24)
kenny = createNode(graph, "Person", name="Kenny", age=27)
shannon = createNode(graph, "Person", name="Shannon", age=23)
```

## <a name="#relationships"></a>Relationships


```r
r1 = createRel(greta, "LIKES", nicole, weight=7)
r2 = createRel(nicole, "LIKES", kenny, weight=1)
r3 = createRel(kenny, "LIKES", shannon, weight=3)
r4 = createRel(nicole, "LIKES", shannon, weight=5)
```

## <a name="#cypher"></a>Cypher

If you're returning tabular results, use `cypher`, which will give you a `data.frame`.


```r
query = "
MATCH (nicole:Person)-[r:LIKES]->(p:Person)
WHERE nicole.name = 'Nicole'
RETURN nicole.name, r.weight, p.name
"

cypher(graph, query)
```

```
##   nicole.name r.weight  p.name
## 1      Nicole        1   Kenny
## 2      Nicole        5 Shannon
```

For anything more complicated, use `cypherToList`, which will give you a `list`.


```r
query = "
MATCH (nicole:Person)-[:LIKES]->(p:Person)
WHERE nicole.name = 'Nicole'
RETURN nicole, COLLECT(p.name) AS friends
"

cypherToList(graph, query)
```

```
## [[1]]
## [[1]]$nicole
## < Node Object > 
## $name
## [1] "Nicole"
## 
## $age
## [1] 24
## 
## 
## [[1]]$friends
## [[1]]$friends[[1]]
## [1] "Kenny"
## 
## [[1]]$friends[[2]]
## [1] "Shannon"
```

## <a name="#shortest-paths"></a>Shortest Paths


```r
p = shortestPath(greta, "LIKES", shannon, max_depth=4)
n = nodes(p)
sapply(n, "[[", "name")
```

```
## [1] "Greta"   "Nicole"  "Shannon"
```

## <a name="#weighted-shortest-paths"></a>Weighted Shortest Paths


```r
p = shortestPath(greta, "LIKES", shannon, max_depth=4, cost_property="weight")
n = nodes(p)
sapply(n, "[[", "name")
```

```
## [1] "Greta"   "Nicole"  "Kenny"   "Shannon"
```

```r
p$weight
```

```
## [1] 11
```

## <a name="#cypher"></a>Graph Algorithms


```r
library(igraph)

query = "
MATCH (n)-->(m)
RETURN n.name, m.name
"

edgelist = cypher(graph, query)
ig = graph.data.frame(edgelist, directed=F)

betweenness(ig)
```

```
##  Nicole   Greta   Kenny Shannon 
##       2       0       0       0
```

```r
closeness(ig)
```

```
##    Nicole     Greta     Kenny   Shannon 
## 0.3333333 0.2000000 0.2500000 0.2500000
```

## <a name="#visualizations"></a>Visualizations

### `igraph`


```r
plot(ig)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png) 

### `ggnet`


```r
library(network)
library(GGally)

net = network(edgelist)
ggnet(net, label.nodes=TRUE)
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-1.png) 

### `visNetwork`

[Read this blog post](http://nicolewhite.github.io/2015/06/18/visualize-your-graph-with-rneo4j-and-visNetwork.html).

## <a name="#import"></a>Import




```r
library(hflights)
hflights = hflights[sample(nrow(hflights), 1000), ]

head(hflights)
```

```
##         Year Month DayofMonth DayOfWeek DepTime ArrTime UniqueCarrier
## 4832354 2011    10         16         7    2252    2354            XE
## 1566415 2011     4          9         6    1817    1915            CO
## 3147457 2011     7          7         4     702    1005            DL
## 2213072 2011     5          3         2    1317    1631            XE
## 4695998 2011    10         12         3    1605    1954            CO
## 463485  2011     1         17         1    1635    1945            XE
##         FlightNum TailNum ActualElapsedTime AirTime ArrDelay DepDelay
## 4832354      4632  N27190                62      45       -1       -3
## 1566415      1779  N37434                58      36        6        2
## 3147457       810  N975DL               123     100       -8        2
## 2213072      2980  N36915               134     102       11       -3
## 4695998      1606  N39728               169     150       -9        0
## 463485       2488  N13118               130     112       -9       -1
##         Origin Dest Distance TaxiIn TaxiOut Cancelled CancellationCode
## 4832354    IAH  MSY      305      6      11         0                 
## 1566415    IAH  SAT      191      3      19         0                 
## 3147457    IAH  ATL      689     12      11         0                 
## 2213072    IAH  TYS      772      5      27         0                 
## 4695998    IAH  DCA     1208      6      13         0                 
## 463485     IAH  CLT      913      6      12         0                 
##         Diverted
## 4832354        0
## 1566415        0
## 3147457        0
## 2213072        0
## 4695998        0
## 463485         0
```

```r
addConstraint(graph, "Carrier", "name")
addConstraint(graph, "Airport", "name")

query = "
CREATE (flight:Flight {number: {FlightNum} })
SET flight.year = TOINT({Year}),
    flight.month = TOINT({DayofMonth}),
    flight.day = TOINT({DayOfWeek})

MERGE (carrier:Carrier {name: {UniqueCarrier} })
CREATE (flight)-[:OPERATED_BY]->(carrier)

MERGE (origin:Airport {name: {Origin} })
MERGE (dest:Airport {name: {Dest} })

CREATE (flight)-[o:ORIGIN]->(origin)
CREATE (flight)-[d:DESTINATION]->(dest)

SET o.delay = TOINT({DepDelay}),
    o.taxi_time = TOINT({TaxiOut})

SET d.delay = TOINT({ArrDelay}),
    d.taxi_time = TOINT({TaxiIn})
"

tx = newTransaction(graph)

for(i in 1:nrow(hflights)) {
  row = hflights[i, ]
  
  appendCypher(tx, query,
               FlightNum=row$FlightNum,
               Year=row$Year,
               DayofMonth=row$DayofMonth,
               DayOfWeek=row$DayOfWeek,
               UniqueCarrier=row$UniqueCarrier,
               Origin=row$Origin,
               Dest=row$Dest,
               DepDelay=row$DepDelay,
               TaxiOut=row$TaxiOut,
               ArrDelay=row$ArrDelay,
               TaxiIn=row$TaxiIn)
}

commit(tx)

summary(graph)
```

```
##     This          To    That
## 1 Flight OPERATED_BY Carrier
## 2 Flight      ORIGIN Airport
## 3 Flight DESTINATION Airport
```
