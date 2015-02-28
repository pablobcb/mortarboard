require('./util')

local http   = require('http')
local router = require('./router')

-- return the handler for all http requests.
-- @param app_middlewares: 
--     [type]: list of functions
--     [desc]: holds registered middlewares with app.use()
-- @param routes
--     [type]: list of functions
--     [desc]: holds registered middlewares with
--             app.get(), app.post(), app.put() and app.delete()
-- @return function
local onRequest = function (app_middlewares, routes)
  return function(req, res)
    -- list of all middlewares that together will
    -- sequentially compute the request
    local request_chain = {}
    request_chain = table.concatenate(request_chain, app_middlewares)

    -- function that will consume asynchronously 
    -- the middlewares of the request chain
    local current_middleware_index = 0
    local function continue()
      current_middleware_index = current_middleware_index + 1
      local current_middleware = request_chain[current_middleware_index]

      if type(current_middleware) == 'nil' then
        return error('can not call "continue" on last middleware of the chain')
      end

      current_middleware(req, res, continue)
    end

    continue()
  end
end

-- creates an application instance.
-- @return table, containing all the app methods
local createApp = function()
  local app       = {} -- hash
  app.middlewares = {} -- list
  app.routes      = {} -- list

  -- register a application middleware, ORDER MATTERS.
  -- @param middleware:
  --     [type]: function
  --     [desc]: middleware to be registered within the app
  app.use = function (middleware)
    table.insert(app.middlewares, middleware)
  end

  -- auxiliary methods for registering new routes.
  -- @param path:
  --     [type]: string
  --     [desc]: path to resource, ex: '/api/customer'
  -- @param route_middlewares:
  --     [type]: list of functions
  --     [desc]: middlewares to be executed after
  --             the app middlewares for the given path
  app.get = function (path, route_middlewares)
    router.create(routes, 'GET', path, route_middlewares)
  end

  app.post = function (path, route_middlewares)
    router.create(routes, 'POST', path, route_middlewares)
  end

  app.put = function (path, route_middlewares)
    router.create(routes, 'PUT', path, route_middlewares)
  end

  app.delete = function (path, route_middlewares)
    router.create(routes, 'DELETE', path, route_middlewares)
  end 

  -- creates and binds a server to a port.
  -- @param port:
  --     [type]: number
  app.listen = function (port)
    if type(port) ~= 'number' then
     error("'port' is a required parameter!")
    end

    local server = http.createServer(
      onRequest(app.middlewares, app.routes)
    )

    return server:listen(port)
  end 

  return app
end

return createApp