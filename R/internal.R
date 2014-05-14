is.empty = function(data) {
  stopifnot(is.data.frame(data))
  row = dim(data)[1]
  col = dim(data)[2]
  return(row == 0 & col == 0)
}

configure_result = function(result) {
  # Only keep things I need for later REST API calls.
  data = result$data
  self = result$self
  property = result$property
  properties = result$properties
  labels = result$labels
  create_relationship = result$create_relationship
  start = result$start
  type = result$type
  end = result$end
  class = class(result)
  
  # Add properties as names.
  length(result) = length(data)
  names(result) = names(data)
  
  # Tried this with lapply with no luck.
  # ?? lapply(names(data), function(x) {result[x] = data[x]}) ??
  for (i in 1:length(data)) {
    name = names(data[i])
    result[name] = data[name]
  }
  
  # Set REST URLs as attributes.
  attr(result, "self") = self
  attr(result, "property") = property
  attr(result, "properties") = properties

  # Add attributes specific to nodes.
  if("node" %in% class) {
    attr(result, "labels") = labels
    attr(result, "create_relationship") = create_relationship
    
  # Add attributes specific to relationships.  
  } else if("relationship" %in% class) {
    attr(result, "start") = start
    attr(result, "type") = type
    attr(result, "end") = end
    
  } else {
    stop("Invalid object.")
  }
  
  class(result) = class
  return(result)
}