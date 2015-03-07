local router = {}

-- creates a route for a given a HTTP method and path
-- @param routes: 
--     [type]: list of functions
--     [desc]: holds registered middlewares with app.method()
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
    path        = path,          -- string lik /uri/with/:placeholders or regexp
    middlewares = middlewares,   -- list of functions with (req, res, next) as signature
    method      = request_method -- string with http method
  })
end


-- check if the given urls match
-- @param req_url: 
--     [type]: string
--     [desc]: url fetched from request, as /user/420/foo
-- @param route url:
--     [type]: string
--     [desc]: path to be matched, ex: '/user/:id/foo'
-- @return boolean
local match_url = function(req_url, route_url)
  local req_url_parts = req_url:split('/')
  local route_url_parts = route_url:split('/')


  if #req_url_parts ~= #route_url_parts then
    return false
  end

  local matched = true
  for i = 1, #route_url_parts do
    local first_char = route_url_parts[i]:sub(1,1)

    if first_char ~= ':' then
      if req_url_parts[i] ~= route_url_parts[i] then
        matched =  false
      end
    end
  end
  return matched
end

-- finds the matched route for a given method and path.
-- @param routes: 
--     [type]: list of functions
--     [desc]: holds registered middlewares with app.method()
-- @param request_method:
--     [type]: string
--     [desc]: HTTP method to be matched
-- @param path:
--     [type]: string
--     [desc]: path to be matched, ex: '/api/customer'
-- @return table holding the matched route, created with route.create
-- returns boolean
router.match = function(routes, request_method, request_path)
  for _, route in ipairs(routes) do
    local url_match    = match_url(request_path, route.path)
    local method_match = route.method == request_method

    if url_match and method_match then
      return route
    end
  end
end

return router