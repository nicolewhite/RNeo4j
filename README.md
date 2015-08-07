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
* [Connection Issues](#connection-issues)

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
## 1      Nicole        5 Shannon
## 2      Nicole        1   Kenny
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
## [1] "Shannon"
## 
## [[1]]$friends[[2]]
## [1] "Kenny"
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
## 3819990 2011     8         18         4     829    1019            XE
## 4891262 2011    10          3         1    1730    1828            OO
## 2128272 2011     5         11         3     854    1013            WN
## 5322365 2011    11         23         3    1922    2020            XE
## 2484740 2011     5          1         7    1849    2225            MQ
## 92043   2011     1          4         2    2115    2241            CO
##         FlightNum TailNum ActualElapsedTime AirTime ArrDelay DepDelay
## 3819990      3056  N12900               110      96       30       39
## 4891262      5161  N764SK               118     103      -12        0
## 2128272      1615  N782SA                79      68      -12       -6
## 5322365      4498  N15932                58      36       -4       -3
## 2484740      3717  N515MQ               216     137       85       24
## 92043         511  N73299                86      60       29       20
##         Origin Dest Distance TaxiIn TaxiOut Cancelled CancellationCode
## 3819990    IAH  MCI      643      4      10         0                 
## 4891262    IAH  ABQ      744      5      10         0                 
## 2128272    HOU  MAF      441      3       8         0                 
## 5322365    IAH  LFT      201      7      15         0                 
## 2484740    IAH  ORD      925     29      50         0                 
## 92043      IAH  MFE      316      5      21         0                 
##         Diverted
## 3819990        0
## 4891262        0
## 2128272        0
## 5322365        0
## 2484740        0
## 92043          0
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

## <a name="#connection-issues"></a>Connection Issues

### Couldn't connect to server
```
Error in curl::curl_fetch_memory(url, handle = handle) : 
  Couldn't connect to server
```

Neo4j probably isn't running. Make sure Neo4j is running first. It's also possible you have localhost resolution issues; try connecting to `http://127.0.0.1:7474/db/data/` instead.

### No authorization header supplied

```
Error: client error: (401) Unauthorized
Neo.ClientError.Security.AuthorizationFailed
No authorization header supplied.
```

You have auth enabled on Neo4j and either didn't provide your username and password or they were invalid. You can pass a username and password to `startGraph`.

```
graph = startGraph("http://localhost:7474/db/data/", username="neo4j", password="password")
```

You can also disable auth by editing the following line in `conf/neo4j-server.properties`.

```
# Require (or disable the requirement of) auth to access Neo4j
dbms.security.auth_enabled=false
```
