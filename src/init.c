#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>


/* .Call calls */
extern SEXP RNeo4j_bolt_begin_internal(SEXP, SEXP, SEXP, SEXP);
extern SEXP RNeo4j_bolt_query_internal(SEXP, SEXP, SEXP, SEXP);
extern SEXP RNeo4j_bolt_supported_internal();

static const R_CallMethodDef CallEntries[] = {
    {"RNeo4j_bolt_begin_internal",     (DL_FUNC) &RNeo4j_bolt_begin_internal,     4},
    {"RNeo4j_bolt_query_internal",     (DL_FUNC) &RNeo4j_bolt_query_internal,     4},
    {"RNeo4j_bolt_supported_internal", (DL_FUNC) &RNeo4j_bolt_supported_internal, 0},
    {NULL, NULL, 0}
};

void R_init_RNeo4j(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
