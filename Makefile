test:
	NEO4J_USERNAME=neo4j NEO4J_PASSWORD=password /usr/bin/Rscript -e 'library(methods);library(testthat);devtools::test();'

start_neo4j: neo4j
	./neo4j/bin/neo4j start || ./neo4j/bin/neo4j restart
