is.empty = function(data) {
  stopifnot(is.data.frame(data))
  row = dim(data)[1]
  col = dim(data)[2]
  return(row == 0 & col == 0)
}

configure_result = function(result, username = NULL, password = NULL) {
  # Only keep things I need for later REST API calls.
  data = result$data
  self = result$self
  property = result$property
  properties = result$properties
  labels = result$labels
  create_rel = result$create_relationship
  inc = result$incoming_relationships
  out = result$outgoing_relationships
  start = result$start
  type = result$type
  end = result$end
  
  if(!is.null(username) && !is.null(password)) {
    userpwd = paste0("http://", username, ":", password, "@")
    
    self = gsub("http://", userpwd, self)
    property = gsub("http://", userpwd, property)
    properties = gsub("http://", userpwd, properties)
    labels = gsub("http://", userpwd, labels)
    create_rel = gsub("http://", userpwd, create_rel)
    inc = gsub("http://", userpwd, inc)
    out = gsub("http://", userpwd, out)
    start = gsub("http://", userpwd, start)
    type = gsub("http://", userpwd, type)
    end = gsub("http://", userpwd, end)
  }
  
  class = class(result)
  
  # Add properties as names.
  length(result) = length(data)
  names(result) = names(data)
  
  for (i in 1:length(data)) {
    name = names(data[i])
    result[name] = data[name]
  }
  
  attr(result, "self") = self
  attr(result, "property") = property
  attr(result, "properties") = properties
  
  if(!is.null(username) && !is.null(password)) {
    attr(result, "username") = username
    attr(result, "password") = password
  }
  
  # Add attributes specific to nodes.
  if("node" %in% class) {
    attr(result, "labels") = labels
    attr(result, "create_relationship") = create_rel
    attr(result, "incoming_relationships") = inc
    attr(result, "outgoing_relationships") = out
    
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

configure_vars = function(label, key, type, direction = character()) {
  label = paste0(":", label)
  type = paste0(":", type)

  inc = ")-["
  out = "]-("
  
  if (length(direction) == 1) {
    if (direction == "incoming") {
      inc = ")<-["
    }
    
    if (direction == "outgoing") {
      out = "]->("
    }
  }
  
  return(list(label, key, type, inc, out))
}

.onLoad = function(...) {
  packageStartupMessage("Disclaimer: This package is in pre-alpha phase. It is not optimized and it has not been thoroughly tested. Make a copy of your database before connecting with this package.")
}

setHeaders = function() {
  list('Accept' = 'application/json', 'Content-Type' = 'application/json')
}

http_request = function(url, request_type, wanted_status, postfields = NULL, httpheader = NULL) {
  t = basicTextGatherer()
  h = basicHeaderGatherer()
  
  opts = list(customrequest = request_type,
              writefunction = t$update,
              headerfunction = h$update)
  
  if(!is.null(postfields)) {
    opts = c(opts, list(postfields = postfields))
  }
  if(!is.null(httpheader)) {
    opts = c(opts, list(httpheader = httpheader))
  }

  curlPerform(url = url, .opts = opts) 
  text = t$value()
  headers = h$value()
  status_message = headers['statusMessage']
  
  if(status_message != wanted_status) {
    status = headers['status']
    stop(status, " ", status_message, "\n\n",
         text,
         call. = FALSE)
  } else {
    return(text)
  }
}