local json = require('json')
local HTTP_STATUS = require('./httpstatus')

-- parses low level data in luvit's reponse
-- into a high level http API (mortarboard api)
-- @param res: 
--     [type]: table
--     [desc]: luvit native 'req' object
-- @return table
return function(res)
  -- if presents in the response table, returns a 
  -- http header value, else it returns nil
  -- @param header: 
  --     [type]: string
  --     [desc]: the http header name
  -- @return string or nil
  res.get = function(header)
    if type(header) ~= 'string' then
      error("'header' parameter must be a string!")
    end

    header = header:lower()
    
    return res.headers[header]
  end

  -- sets a http header in the response table
  -- @param header: 
  --     [type]: string
  --     [desc]: the http header name
  -- @param value: 
  --     [type]: string
  --     [desc]: the http header value
  res.set = function (header, value)
    if type(header) ~= 'string' then
      error("'header' parameter must be a a string!")
    end

    if type(value) == 'number' then
      value = tostring(value)
    end

    if type(value) ~= 'string' then
      error("'header value' parameter must be a a string!")
    end

    header = header:lower()
    value  = value:lower()

    res:setHeader(header, value)
  end

  -- finishes the req/res cycle, setting the content-lenght header
  -- and then sends the response object to the client.
  -- @param body: 
  --     [type]: string, number
  --     [desc]: data to be sent as http's response payload
  res.send = function (body)
    if type(body) == 'nil' then
      body = ''
    end

    res.set('content-length', #body)

    res:finish(body)
  end

  -- finishes the req/res cycle, setting the content-lenght header,
  -- the content-type header as application/json and then sends 
  -- the response object to the client.
  -- @param body: 
  --     [type]: string, number
  --     [desc]: data to be sent as http's response payload
  res.json = function (body)
    if type(body) ~= 'table' then
      --error("'body' parameter must be a table!")
    end

    local json_string = json.encode(body)

    res.set('content-type' , 'application/json')
    res.set('content-length', #body)

    res.send(json_string)
  end

  -- sets the http response status code.
  -- @param status: 
  --     [type]: number
  --     [desc]: the http status code
  -- @return table
  res.status = function (status)
    if type(status) ~= 'number' then
      error("'status' parameter must be a number!")
    end

    res.statusCode = status
    return res
  end

  -- sets the http response status code, the content-lenght
  -- and sends a msg corresponding to the http status code
  -- @param header: 
  --     [type]: number
  --     [desc]: the http status code
  res.sendStatus = function(status)
    local msg = HTTP_STATUS[status]

    res.set('content-length', #msg)

    res.status(status).send(msg)
  end

  return res
end
