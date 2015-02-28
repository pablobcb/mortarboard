local json = require('json')

return function (options)
   -- TODO: use options
   if not options then
     options = {} 
   end
  
  return function (req, res, done)
    if req.get('content-type') == 'application/json' then
      local body = json.parse(req.raw_body, 1, json.null)

      if not body then
        return res.sendStatus(400)
      end

      req.body = body
    end

    done()
  end
end

