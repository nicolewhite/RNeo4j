# RNeo4j [![Build Status](https://travis-ci.org/nicolewhite/RNeo4j.svg?branch=master)](https://travis-ci.org/nicolewhite/RNeo4j)

RNeo4j is Neo4j's R driver. It allows you to read and write data from / to Neo4j directly from your R environment.

## Contents

<img align="right" src="figure/RNeo4j-logo.png" />

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
* [Contribute](#contribute)

## <a name="#install"></a>Install

### Neo4j

First and foremost, [download Neo4j](http://neo4j.com/download/other-releases/)!

#### Windows

If you're on Windows, download the `.exe` and follow the instructions. You'll get a GUI where you simply press "Start" to start Neo4j.

#### OS X

If you're on OS X, you can download either the `.dmg` or the `.tar.gz`. The `.dmg` will give you a GUI where you simply press "Start" to start Neo4j. Otherwise, download the `.tar.gz`, unzip, navigate to the directory and execute `./bin/neo4j start`.

#### Linux

If you're on Linux, you have to use the `.tar.gz`. Download the `.tar.gz`, unzip, navigate to the directory and execute `./bin/neo4j start`.

You may also find neo4j in your distribution's package manager.

### Bolt dependencies

These depencies are are only required if you want to use the Bolt interface.
They must be present at build time, and `libneo4j-client` must also be present at runtime.

#### Windows

- Rust: https://rustup.rs
- Clang: binary releases are available at http://releases.llvm.org/download.html
- libneo4j-client:
    - Make sure you have RTools installed (necessary for building R packages on Windows)
    - Open your MinGW shell (check in start menu, `C:\RTools\MinGW\bin`, and `C:\MinGW\bin`)
    - See "Installing libneo4j-from source" section

#### OS X (with Homebrew installed)

- Rust: `brew install rust` (or https://rustup.rs but see "Rust Path" section)
- Clang: `brew install llvm`
- libneo4j-client: `brew install cleishm/neo4j/libneo4j-client`

#### Linux

- Rust:
    - Debian based (e.g. Mint, Ubuntu): `sudo apt-get install cargo`
    - Arch Linux: `sudo pacman -S rust`
    - Building from source: https://rustup.rs but see "Rust Path" section
- Clang: get it from your package manager
    - Debian based (e.g. Mint, Ubuntu): `sudo apt-get install clang`
    - Arch Linux: `sudo pacman -S clang`
    - Other: your package manager almost certainly has `clang`. It may be called `llvm`.
- libneo4j-client:
    - Debian based: `sudo apt-get install libneo4j-client-dev`
    - Other: See "Installing libneo4j-client from source"

#### Rust Path

By default, on *nix systems (such as Linux and OS X), rustup only sets the PATH in your shell.
That means that if you try to build RNeo4j in a GUI application like RStudio, it may fail.
To work around this issue, simply build RNeo4j in a terminal.

#### Installing libneo4j-client from source

Newer versions of GCC require removing the `-Werror` from `GCC_CFLAGS` in `configure.ac`.

Run these commands in your shell:

```sh
git clone https://github.com/cleishm/libneo4j-client
cd libneo4j-client
./autogen.sh
./configure --disable-tools
sudo make install
```

See https://github.com/cleishm/libneo4j-client for more details


### RNeo4j

#### From CRAN


```r
install.packages("RNeo4j")
```

#### From GitHub


```r
devtools::install_github("nicolewhite/RNeo4j")
```

#### From Source

Go to the [latest release](https://github.com/nicolewhite/RNeo4j/releases/latest) and download the source code. You can then install with `install.packages`.


```r
install.packages("/path/to/file.tar.gz", repos=NULL, type="source")
```

#### Load the Package


```r
library(RNeo4j)
```

## <a name="#connect"></a>Connect


```r
graph = startGraph("http://localhost:7474/db/data/")
```

If you have authentication enabled, pass your username and password.


```r
graph = startGraph("http://localhost:7474/db/data/", username="neo4j", password="password")
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
## < Node > 
## Person
## 
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

Both `cypher` and `cypherToList` accept parameters. These parameters can be passed individually or as a list.


```r
query = "
MATCH (p1:Person)-[r:LIKES]->(p2:Person)
WHERE p1.name = {name1} AND p2.name = {name2}
RETURN p1.name, r.weight, p2.name
"

cypher(graph, query, name1="Nicole", name2="Shannon")
```

```
##   p1.name r.weight p2.name
## 1  Nicole        5 Shannon
```

```r
cypher(graph, query, list(name1="Nicole", name2="Shannon"))
```

```
##   p1.name r.weight p2.name
## 1  Nicole        5 Shannon
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

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png) 

### `ggnet`


```r
library(network)
library(GGally)

net = network(edgelist)
ggnet(net, label.nodes=TRUE)
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17-1.png) 

### `visNetwork`

[Read this blog post](http://neo4j.com/blog/visualize-graph-with-rneo4j/) and [check out this slide deck](http://nicolewhite.github.io/neo4j-presentations/RNeo4j/Visualizations/Visualizations.html#1).

## <a name="#import"></a>Import




```r
library(hflights)
hflights = hflights[sample(nrow(hflights), 1000), ]
row.names(hflights) = NULL

head(hflights)
```

```
##   Year Month DayofMonth DayOfWeek DepTime ArrTime UniqueCarrier FlightNum
## 1 2011     1         15         6     927    1038            XE      2885
## 2 2011    10         10         1    2001    2322            XE      4243
## 3 2011     6         15         3    1853    2108            CO       670
## 4 2011     4         10         7    2100     102            CO       410
## 5 2011     1         25         2     739    1016            XE      3083
## 6 2011     9         13         2    1745    1841            CO      1204
##   TailNum ActualElapsedTime AirTime ArrDelay DepDelay Origin Dest Distance
## 1  N34110               131     113      -10       -3    IAH  COS      809
## 2  N13970               141     127        2       19    IAH  CMH      986
## 3  N36207               255     231       15       -2    IAH  SFO     1635
## 4  N76517               182     162      -18        5    IAH  EWR     1400
## 5  N12922               157     128        0       -6    IAH  MKE      984
## 6  N35271                56      34       -7       -5    IAH  SAT      191
##   TaxiIn TaxiOut Cancelled CancellationCode Diverted
## 1      6      12         0                         0
## 2      4      10         0                         0
## 3      5      19         0                         0
## 4      7      13         0                         0
## 5      4      25         0                         0
## 6      3      19         0                         0
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

## <a name="#contribute"></a>Contribute

Check out [the contributing doc](https://github.com/nicolewhite/RNeo4j/blob/master/CONTRIBUTING.md) if you'd like to contribute!
