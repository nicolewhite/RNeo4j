is.empty = function(data) {
  stopifnot(is.data.frame(data))
  
  row = dim(data)[1]
  col = dim(data)[2]
  
  return(row == 0 & col == 0)
}

configure_result = function(result) {
  new = list()
  data = result$data
  
  length(new) = length(data)
  names(new) = names(data)
  
  # Add data properties as names.
  if(length(data) > 0) {
    for (i in 1:length(data)) {
      new[names(data[i])] = data[[i]]
    }
  }
  
  # Only keep attributes needed for REST API.
  attr(new, "self") = result$self
  attr(new, "property") = result$property
  attr(new, "properties") = result$properties
  
  # Add attributes specific to nodes.
  if("node" %in% class(result)) {
    attr(new, "labels") = result$labels
    attr(new, "create_relationship") = result$create_relationship
    
  # Add attributes specific to relationships.  
  } else {
    attr(new, "start") = result$start
    attr(new, "type") = result$type
    attr(new, "end") = result$end
  }

  class(new) = class(result)
  return(new)
}