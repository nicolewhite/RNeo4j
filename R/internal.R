version = function() {
  return("1.2.0")
}

configure_result = function(result, username = NULL, password = NULL, auth_token=NULL) {
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
  class = class(result)
  
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

  if("path" %in% class) {
    length(result) = 1
    names(result) = "length"
    result["length"] = len
    attr(result, "start") = start
    attr(result, "end") = end
    attr(result, "nodes") = nodes
    attr(result, "relationships") = rels
  }
  
  if("node" %in% class) {
    attr(result, "labels") = labels
    attr(result, "create_relationship") = create_rel
    attr(result, "incoming_relationships") = inc
    attr(result, "outgoing_relationships") = out
  } 
  
  if("relationship" %in% class) {
    attr(result, "start") = start
    attr(result, "type") = type
    attr(result, "end") = end
  }
  
  if(!is.null(username) && !is.null(password)) {
    attr(result, "username") = username
    attr(result, "password") = password
  }
  
  if(!is.null(auth_token)) {
    attr(result, "auth_token") = auth_token
  }
  
  class(result) = class
  return(result)
}

setBasicAuthHeader = function(headers, username, password, realm=NULL) {
  credentials = paste0(username, ":", password)
  
  if(!is.null(realm)) {
    auth = paste0('Basic realm="', realm, '" ')
  } else {
    auth = 'Basic '
  }
  
  auth = paste0(auth, base64(credentials)[1])
  headers = c(headers, list('Authorization' = auth))
  return(headers)
}

setHeaders = function(entity) {
  headers = list('Accept' = 'application/json', 
                 'Content-Type' = 'application/json',
                 'X-Stream' = TRUE)
  
  username = attr(entity, "username")
  password = attr(entity, "password")
  auth_token = attr(entity, "auth_token")
  
  if(!is.null(username) && !is.null(password)) {
    headers = setBasicAuthHeader(headers, username, password)
  } else if(!is.null(auth_token)) {
    headers = setBasicAuthHeader(headers, "", auth_token, realm="Neo4j")
  }
  
  return(headers)
}

http_request = function(url, request_type, wanted_status, postfields = NULL, httpheader = NULL, addtl_opts = list()) {
  t = basicTextGatherer()
  h = basicHeaderGatherer()
  
  opts = list(customrequest = request_type,
              writefunction = t$update,
              headerfunction = h$update,
              useragent = paste0("RNeo4j/", version()))
  
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
  header = setHeaders(graph)
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