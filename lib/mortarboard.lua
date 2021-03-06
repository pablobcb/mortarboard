require('./util')
local _table = require('table')

local http     = require('http')
local router   = require('./router')
local request  = require('./request')
local response = require('./response')
local logger   = require('./middleware/logger')

-- return the handler for all http requests.
-- @param app_middlewares: 
--     [type]: list of functions
--     [desc]: holds registered middlewares with app.use()
-- @param routes
--     [type]: list of functions
--     [desc]: holds registered middlewares with
--             app.get(), app.post(), app.put() and app.delete()
-- @return function
local onRequest = function (app)
  return function(req, res)

    -- creates the request and response API
    req = request(req)
    res = response(res)

    local matched_route = router.match(app.routes, req.method, req.path)

    if not matched_route then
      return res.sendStatus(404)
    end


    -- parse placehold paramaters such as /foo/:bar
    req._parseParams(matched_route.path)

    -- list of all middlewares that together will
    -- sequentially compute the request
    local request_chain = {}
    
    request_chain = table.merge(request_chain, app.middlewares)
    request_chain = table.merge(request_chain, matched_route.middlewares)

    -- function that will consume asynchronously 
    -- the middlewares of the request chain
    local current_middleware_index = 0
    local function continue()
      local success, err = pcall(function ()
        current_middleware_index = current_middleware_index + 1
        local current_middleware = request_chain[current_middleware_index]

        if type(current_middleware) == 'nil' then
          return error('can not call "continue" on last middleware of the chain')
        end

        current_middleware(req, res, continue)
      end)

      if not success then 
        print('[mortarboard]: ERROR -> ' .. err)
        return res.sendStatus(500)
      end
    end

    continue()
  end
end

-- creates an application instance.
-- @return table, containing all the app methods
local createApp = function()
  -- TODO: move this to app module
  local app       = {} -- hash
  app.middlewares = {
    function (req, res, done)
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
  } -- list
  app.routes      = {} -- list

  -- register a application middleware, ORDER MATTERS.
  -- @param middleware:
  --     [type]: function
  --     [desc]: middleware to be registered within the app
  app.use = function (middleware)
    table.insert(app.middlewares, middleware)
  end

  -- app config
  app.use(logger)

  -- auxiliary methods for registering new routes.
  -- @param path:
  --     [type]: string
  --     [desc]: path to resource, ex: '/api/customer'
  -- @param route_middlewares:
  --     [type]: list of functions
  --     [desc]: middlewares to be executed after
  --             the app middlewares for the given path
  app.get = function (path, route_middlewares)
    router.create(app.routes, 'GET', path, route_middlewares)
  end

  app.post = function (path, route_middlewares)
    router.create(app.routes, 'POST', path, route_middlewares)
  end

  app.put = function (path, route_middlewares)
    router.create(app.routes, 'PUT', path, route_middlewares)
  end

  app.delete = function (path, route_middlewares)
    router.create(app.routes, 'DELETE', path, route_middlewares)
  end

  app.method = function (method)
    return  function (path, route_middlewares)
      router.create(app.routes, method, path, route_middlewares)
    end
  end

  -- creates and binds a server to a port.
  -- @param port:
  --     [type]: number
  app.listen = function (port)
    if type(port) ~= 'number' then
     error("'port' is a required parameter!")
    end

    local server = http.createServer(
      onRequest(app)
    )

    return server:listen(port)
  end 

  return app
end

return createApp
