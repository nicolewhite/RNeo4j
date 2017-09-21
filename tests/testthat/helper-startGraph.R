startTestGraph = function(sample) {
  if (!is.na(Sys.getenv("NEO4J_BOLT", NA))) {
    neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password", boltUri = "neo4j://localhost:7687")
  } else {
    neo4j = startGraph("http://localhost:7474/db/data/", "neo4j", "password")
  }
  if (missing(sample)) {
    clear(neo4j, input=F)
  } else {
    importSample(neo4j, "movies", input=F)
  }
  return(neo4j)
}