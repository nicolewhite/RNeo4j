test:
	/usr/bin/Rscript -e 'library(methods);library(testthat);devtools::test();'

start_neo4j:
	./neo4j/bin/neo4j start || ./neo4j/bin/neo4j restart

stop_neo4j:
	./neo4j/bin/neo4j stop

install:
	R CMD INSTALL --no-multiarch --with-keep.source ../RNeo4j

source:
	R CMD build ../RNeo4j

binary:
	R CMD INSTALL --build --preclean ../RNeo4j

update:
	sed 's/$(OLD)/$(NEW)/' DESCRIPTION > tempfile && mv tempfile DESCRIPTION
	sed 's/$(OLD)/$(NEW)/' man/RNeo4j-package.Rd > tempfile && mv tempfile man/RNeo4j-package.Rd
	sed 's/$(OLD)/$(NEW)/' R/internal.R > tempfile && mv tempfile R/internal.R