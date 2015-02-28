local _table = require('table')

return function (req, res, done)
  local payload = {}
  local length  = 0

  req:on('data', function (chunk, len)
    length = length + 1
    payload[length] = chunk
  end)

  req:on('end', function ()
    req.raw_body = _table.concat(payload)
    done()
  end)
end