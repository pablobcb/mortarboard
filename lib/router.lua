local router = {}

-- creates a route for a given a HTTP method and path
-- @param routes: 
--     [type]: list of functions
--     [desc]: holds registered middlewares with app.VERB()
-- @param request_method:
--     [type]: string
--     [desc]: HTTP method associated with the route
-- @param path:
--     [type]: string
--     [desc]: path to resource, ex: '/api/customer'
-- @param ...:
--     [type]: list of functions
--     [desc]: list holding the middlewares for the given path
router.create = function(routes, request_method, path, ...)
  if type(request_method) ~= 'string' then
    return error('1st argument "method" should be a string, got ' .. type(request_method) .. 'instead')
  end

  if type(path) ~= 'string' then
    return error('2nd argument "path" should be a string, got ' .. type(path) .. 'instead')
  end

  -- TODO: inspect arguments to see if theres 
  -- anything that is not a function
  local middlewares = table.flatten({...})

  table.insert(routes, {
    path        = path,        -- string lik /uri/with/:placeholders or regexp
    middlewares = middlewares, -- list of functions with (req, res, next) as signature
    method      = method       -- string with http method
  })
end

-- finds the matched route for a given method and path.
-- @param routes: 
--     [type]: list of functions
--     [desc]: holds registered middlewares with app.VERB()
-- @param request_method:
--     [type]: string
--     [desc]: HTTP method to be matched
-- @param path:
--     [type]: string
--     [desc]: path to be matched, ex: '/api/customer'
-- @return table holding the matched route, created with route.create
router.match = function(routes, request_method, request_path)
  return table.find(routes, function(route)
    return route.path == request_path and route.method == request_method
  end)
end

return router