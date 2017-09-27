#!/usr/bin/env Rscript
df=as.data.frame(devtools::test())
if(sum(df$failed) > 0 || any(df$error)) {
    q(status=1)
}