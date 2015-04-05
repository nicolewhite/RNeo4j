test:
	NEO4J_USERNAME=neo4j NEO4J_PASSWORD=password /usr/bin/Rscript -e 'library(methods);library(testthat);devtools::test();'

start_neo4j: neo4j
	./neo4j/bin/neo4j start || ./neo4j/bin/neo4j restart

install:
	R CMD INSTALL --no-multiarch --with-keep.source ../RNeo4j

source:
	R CMD build ../RNeo4j

binary:
	R CMD INSTALL --build --preclean ../RNeo4j