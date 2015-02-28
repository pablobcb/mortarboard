local parse_json = require('json').parse

return function (options)
   -- TODO: use options
   if not options then
     options = {} 
   end
  
  return function (req, res, done)
    if req.get('content-type') == 'application/json' then
      req.body = parse_json(req.raw_body)
    end

    done()
  end
end

