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
  nodes = result$nodes
  len = result$length
  rels = result$relationships
  
  # There's probably a better way to do this.
  if(!is.null(username) && !is.null(password)) {
    if (substr(self, 1, 5) == "https") {
      front = "https://"
    } else {
      front = "http://"
    }
    
    userpwd = paste0(front, username, ":", password, "@")
    
    self = gsub(front, userpwd, self)
    property = gsub(front, userpwd, property)
    properties = gsub(front, userpwd, properties)
    labels = gsub(front, userpwd, labels)
    create_rel = gsub(front, userpwd, create_rel)
    inc = gsub(front, userpwd, inc)
    out = gsub(front, userpwd, out)
    start = gsub(front, userpwd, start)
    type = gsub(front, userpwd, type)
    end = gsub(front, userpwd, end)
    nodes = gsub(front, userpwd, nodes)
    len = gsub(front, userpwd, len)
    rels = gsub(front, userpwd, rels)
  }
  
  class = class(result)
  
  # Add properties as names.
  if("node" %in% class | "relationship" %in% class) {
    length(result) = length(data)
    names(result) = names(data)
    
    for (i in 1:length(data)) {
      name = names(data[i])
      result[name] = data[name]
    }
    
    attr(result, "self") = self
    attr(result, "property") = property
    attr(result, "properties") = properties
  }

  # Remove names and add attributes.
  if("path" %in% class) {
    length(result) = 1
    names(result) = "length"
    result["length"] = len
    attr(result, "start") = start
    attr(result, "end") = end
    attr(result, "nodes") = nodes
    attr(result, "relationships") = rels
  }
  
  # Add username and password as attributes.
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
  } 
  
  if("relationship" %in% class) {
    attr(result, "start") = start
    attr(result, "type") = type
    attr(result, "end") = end
    
  }
  
  class(result) = class
  return(result)
}

setHeaders = function() {
  list('Accept' = 'application/json', 
       'Content-Type' = 'application/json',
       'X-Stream' = TRUE)
}

http_request = function(url, request_type, wanted_status, postfields = NULL, httpheader = NULL, addtl_opts = list()) {
  t = basicTextGatherer()
  h = basicHeaderGatherer()
  
  opts = list(customrequest = request_type,
              writefunction = t$update,
              headerfunction = h$update,
              useragent = "RNeo4j/1.1.0")
  
  if(!is.null(postfields)) {
    opts = c(opts, list(postfields = postfields))
  }
  if(!is.null(httpheader)) {
    opts = c(opts, list(httpheader = httpheader))
  }
  if(length(addtl_opts) > 0) {
    opts = c(opts, addtl_opts)
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

find_max_dig = function(params) {
  max_dig = 0
  if(any(sapply(params, class) == "numeric")) {
    max_dig = max(unlist(sapply(params[sapply(params, class) == "numeric"], nchar)))
  }
  return(max_dig)
}

cypher_endpoint = function(graph, query, params) {
  header = setHeaders()
  fields = list(query = query)
  
  if(length(params) > 0) {
    fields = c(fields, params = list(params))
    max_digits = find_max_dig(params)
  }
  
  fields = toJSON(fields, digits = max_digits)
  url = attr(graph, "cypher")
  response = http_request(url,
                          "POST",
                          "OK",
                          postfields = fields,
                          httpheader = header,
                          addtl_opts = attr(graph, "opts"))
  
  result = fromJSON(response)  
  return(result)
}