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
	sed 's/$(OLD)/$(NEW)/' R/internal.R > tempfile && mv tempfile R/internal.R

version:
	/usr/bin/Rscript -e 'packageDescription("RNeo4j")["Version"];'
	
readme:
	/usr/bin/Rscript -e 'library(knitr);knit("README.Rmd", "README.md");'
	
download_neo4j:
	./neoget
	rm -rf neo4j
	mkdir neo4j
	tar -xvzf *.tar.gz -C neo4j --strip-components=1
	rm *.tar.gz
	cd neo4j/conf && sed 's/auth_enabled=true/auth_enabled=false/g' neo4j-server.properties > tempfile && mv tempfile neo4j-server.properties
	
cran:
	- rm *.tar.gz
	/usr/bin/Rscript -e 'library(methods);library(testthat);devtools::build(path=".");'
	R CMD check --as-cran *.tar.gz
	rm -rf RNeo4j.Rcheck
	
pdf:
	R CMD Rd2pdf ../RNeo4j
	rm -rf .*Rd2pdf
