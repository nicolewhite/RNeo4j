is.empty = function(data) {
  stopifnot(is.data.frame(data))
  
  row = dim(data)[1]
  col = dim(data)[2]
  
  return(row == 0 & col == 0)
}