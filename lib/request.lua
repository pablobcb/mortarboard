local qs = require("querystring")
-- creates the request api
return function(req)

  req.hostname, req.port = req.headers.host:match('([^,]+):([^,]+)')
  --req.ip = req.socket.address().ip
  req.ip = req.socket._handle:getpeername().ip

  req.original_url = req.url

  req.path = req.original_url:match('(.-)%?') or req.original_url

  -- aux variable
  local _, querystring = req.original_url:match('([^,]+)?([^,]+)')

  if querystring then
    req.query = qs.parse(querystring)
  end

  req.protocol = req.socket.options and 'https' or 'http'

  req.secure = req.protocol == 'https'

  req.get = function(header)
    if type(header) ~= 'string' then
      error("'header' parameter must be a string!")
    end

    header = header:lower()
    
    return req.headers[header]
  end

  -- params parse

  req._parseParams = function(route_path)
    local params = {}

    local req_url_parts = req.path:split('/')
    local route_url_parts = route_path:split('/')

    for i, route_url_part in ipairs(route_url_parts) do
      local first_char = route_url_parts[i]:sub(1,1)

      if first_char == ":" then
        local placeholder_value = req_url_parts[i]
        local placeholder_name  = route_url_parts[i]
        -- removing the ':'' from the placeholder name
        placeholder_name  = string.sub(route_url_parts[i], 2, #placeholder_name)
        params[placeholder_name] = placeholder_value
      end 
    end

    req.params = params
  end

  return req
end
