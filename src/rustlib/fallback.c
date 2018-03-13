#include <Rinternals.h>
#include <R.h>

#define ERR_MSG "Bolt support was not built, as either libneo4j-client, " \
    "libclang, or Rust were missing at compile time. " \
    "See RNeo4j README for more details."

SEXP rustr_bolt_begin_internal(SEXP uri, SEXP http_url, SEXP username, SEXP password) {
    error(ERR_MSG);
}

SEXP rustr_bolt_query_internal(SEXP graph, SEXP query, SEXP params, SEXP as_data_frame) {
    error(ERR_MSG);
}

SEXP rustr_bolt_supported_internal() {
    return ScalarLogical(0);
}