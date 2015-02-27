local router = {}

router.create = function(routes, method, path, ...)
  if type(method) ~= 'string' then
    return error('1st argument "method" should be a string, got ' .. type(method) .. 'instead')
  end

  if type(path) ~= 'string' then
    return error('2nd argument "path" should be a string, got ' .. type(path) .. 'instead')
  end

  -- TODO: inspect arguments to see if theres 
  -- anything theres not a function
  local middlewares = table.flatten({...})

  table.insert(routes, {
    path        = path,        -- string lik /uri/with/:placeholders or regexp
    middlewares = middlewares, -- list of functions with (req, res, next) as signature
    method      = method       -- string with http method
  })

end

router.match = function(routes, request_method, request_path)
  return table.first(routes, function(route)
    return route.path == request_path and route.method == request_method
  end)
end

return router