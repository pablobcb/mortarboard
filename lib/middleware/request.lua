return function(req, res, done)
  req.hostname, req.port = req.headers.host:match('([^,]+):([^,]+)')
  --req.ip = req.socket.address().ip
  req.ip = req.socket._handle:getpeername().ip
  req.original_url = req.url
  req.path = req.original_url:match('(.-)%?') or req.original_url
  req.protocol = req.socket.options and 'https' or 'http'
  req.secure = req.protocol == 'https'

  req.get = function(header)
    if type(header) ~= 'string' then
      error("'header' parameter must be a string!")
    end

    header = header:lower()
    
    return req.headers[header]
  end

  done()
end
