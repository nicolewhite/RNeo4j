test:
	tests/test.sh

test_all:
	Rscript -e 'devtools::install()'
	python neokit/neorun.py -- --start=neo4j -v 3.0.4 -p password
	make test
	python neokit/neorun.py -- --stop=neo4j
	python neokit/neorun.py -- --start=neo4j -v 2.3.6 -p password
	make test
	python neokit/neorun.py -- --stop=neo4j
	python neokit/neorun.py -- --start=neo4j -v 2.2.10 -p password
	make test
	python neokit/neorun.py -- --stop=neo4j

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
	/usr/local/bin/Rscript -e 'packageDescription("RNeo4j")["Version"];'
	
readme:
	/usr/local/bin/Rscript -e 'library(knitr);knit("README.Rmd", "README.md");'
	
# no longer needed as test_all will do this automatically
download_neo4j:
	python neokit/neoget.py -- -v 3.0.4
	python neokit/neoget.py -- -v 2.3.6
	python neokit/neoget.py -- -v 2.2.10
	
cran:
	PATH="$PATH:/Library/TeX/texbin/pdflatex"
	-rm *.tar.gz
	./build.sh
	R CMD check --as-cran *.tar.gz
	rm -rf RNeo4j.Rcheck
	
pdf:
	R CMD Rd2pdf ../RNeo4j
	rm -rf .*Rd2pdf
