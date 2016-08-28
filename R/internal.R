version = function() {
  return("1.7.0")
}

#' @importFrom utils assignInNamespace
.onLoad = function(libname, pkgname) {
  length.path = function(obj) {
    return(length(unclass(obj)))
  }
  
  assignInNamespace('length.path', length.path, 'httr')
}

configure_result = function(result) {
  if(is.character(result) | is.numeric(result)) {
    return(result)
  }
  
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
  weight = result$weight
  
  # Nodes and Relationships
  if(!is.null(labels) | !is.null(type)) {
    length(result) = length(data)
    names(result) = names(data)
    
    if(length(data) > 0) {
      for (i in 1:length(data)) {
        name = names(data[i])
        depth = length(data[name][[1]])
        
        if (depth == 0) {
          result[[name]] = data[[name]]
        } else if (depth == 1) {
          result[[name]] = data[name][[1]][[1]]
        } else {
          result[[name]] = unlist(data[name][[1]])
        }
      }
    }
    
    attr(result, "self") = self
    attr(result, "property") = property
    attr(result, "properties") = properties
  }
  
  # Nodes
  if(!is.null(labels)) {
    attr(result, "labels") = labels
    attr(result, "create_relationship") = create_rel
    attr(result, "incoming_relationships") = inc
    attr(result, "outgoing_relationships") = out
    class(result) = c("entity", "node")
  } 
  
  # Relationships
  if(!is.null(type)) {
    attr(result, "start") = start
    attr(result, "type") = type
    attr(result, "end") = end
    class(result) = c("entity", "relationship")
  }

  # Paths
  if(!is.null(nodes)) {
    if(!is.null(weight)) {
      length(result) = 2
      names(result) = c("length", "weight")
      result["weight"] = weight
    } else {
      length(result) = 1
      names(result) = "length"
    }
    result["length"] = len
    attr(result, "start") = start
    attr(result, "end") = end
    attr(result, "nodes") = nodes
    attr(result, "relationships") = rels
    class(result) = "path"
  }
  
  return(result)
}

http_request = function(url, request_type, body=NULL) {
  httr::set_config(httr::user_agent(paste("RNeo4j", version(), sep="/")))
  opts = c(.state$opts, ssl_verifypeer = 0)
  
  username = .state$username
  password = .state$password
  
  if(!is.null(username) && !is.null(password)) {
    auth = httr::authenticate(username, password, type="basic")
    httr::set_config(auth)
  }
  
  if (!is.null(body)) {
    body = jsonlite::toJSON(body, auto_unbox=TRUE, null="null")
  }
  
  response = httr::VERB(request_type, url=url, config=httr::config(opts), body=body)
  status_code = httr::status_code(response)
  content = httr::content(response)
  
  if(status_code >= 300 || status_code < 200) {
    status = httr::http_status(response)
    message = status["message"]
    
    if("errors" %in% names(content)) {
      error = content$errors[[1]]
      message = paste(message, error["code"], error["message"], sep="\n")
    }
    
    stop(message, call.=FALSE)
  }
  
  return(content)
}

cypher_endpoint = function(graph, query, params) {
  body = list(query = query)
  
  if(length(params) > 0) {
    body = c(body, params = list(params))
  }
  
  url = attr(graph, "cypher")
  response = http_request(url, "POST", body)
  return(response)
}

shortest_path_algo = function(all, algo, fromNode, relType, toNode, direction = "out", max_depth = 1, cost_property=character()) {
  stopifnot(is.character(relType), 
            "node" %in% class(toNode),
            direction %in% c("in", "out", "all"),
            is.numeric(max_depth),
            is.character(cost_property))
  
  if(algo == "dijkstra" & length(cost_property) == 0) {
    stop("Must specificy the name of the cost property if using the dijkstra algorithm.")
  }
  
  path = ifelse(all, "paths", "path")
  
  url = paste(attr(fromNode, "self"), path, sep = "/")
  to = attr(toNode, "self")
  fields = list(to = to, relationships = list(type = relType, direction = direction), algorithm = algo)
  
  if(algo == "shortestPath") {
    fields = c(fields, list(max_depth=max_depth))
  } else if(algo == "dijkstra") {
    fields = c(fields, list(cost_property=cost_property))
  }
  
  result = try(http_request(url, "POST", fields), silent = T)
  
  if(class(result) == "try-error") {
    return(invisible())
  }
  
  if(length(result) == 0) {
    return(invisible())
  }
  
  if(all) {
    paths = lapply(result, function(r) configure_result(r))
    return(paths)
  } else {
    path = configure_result(result)
    return(path)
  }
}

check_nested_depth = function(col) {
  max(unlist(sapply(col, function(x) {sapply(x, length)})))
}

longest_digit = function(params) {
  types = sapply(params, class)
  max_dig = 0
  new_max = 0
  
  for (i in 1:length(types)) {
    if (types[[i]] == "list") {
      new_max = longest_digit(params[[i]])
    } else if (types[[i]] == "numeric") {
      new_max = max(sapply(params[[i]], number_length))
    } else {
      new_max = 0
    }
    
    if (new_max > max_dig) {
      max_dig = new_max 
    }
  }
  
  return(max_dig)
}

is_float = function(x) {
  return(x %% 1 != 0)
}

number_length = function(x) {
  return(if(is_float(x)) nchar(x) - 1 else nchar(x))
}

parse_dots = function(dots) {
  if(length(dots) == 0) {
    params = list()
  } else if(is.null(names(dots))) {
    params = as.list(dots[[1]])
  } else {
    params = dots
  }
  
  return(params)
}
