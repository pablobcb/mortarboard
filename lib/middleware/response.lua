local json = require('json')
local HTTP_STATUS = require('../httpstatus')

return function(req, res, done)

  res.get = function(header)
    if type(header) ~= 'string' then
      error("'header' parameter must be a string!")
    end

    header = header:lower()
    
    return req.headers[header]
  end

  res.set = function (header, value)
    if type(header) ~= 'string' then
      error("'header' parameter must be a a string!")
    end

    if type(header) ~= 'string' then
      error("'header value' parameter must be a a string!")
    end

    header = header:lower()
    value  = value:lower()

    res.headers[header] = value
  end

  res.send = function (body)
    if type(body) == 'nil' then
      body = ''
    end

    res:writeHead(res.statusCode, {
      ["Content-Length"] = #body
    })

    res:finish(body)
  end

  res.json = function (body)
    if type(body) ~= 'table' then
      error("'body' parameter must be a table!")
    end

    res.set('content-type' , 'application/json')

    res.send(json.encode(body))
  end

  res.status = function (status)
    if type(status) ~= 'number' then
      error("'status' parameter must be a number!")
    end

    res.statusCode = status
    return res
  end

  res.sendStatus = function(status)
    res.status(status).send(HTTP_STATUS[status])
  end

  done()
end