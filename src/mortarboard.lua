require('./util')

local http   = require('http')
local router = require('./router')

local requestHandler = function (appMiddlewares, routes)
  return function(req, res)
    -- list of all middlewares that will
    -- sequentially compute the request
    local requestChain = {}
    requestChain = table.concatenate(requestChain, appMiddlewares)

    local currentMiddlewareIndex = 0

    -- function that will consume asynchronously 
    -- the middlewares of the request chain
    local function continue()
      currentMiddlewareIndex = currentMiddlewareIndex + 1
      local currentMiddleware = requestChain[currentMiddlewareIndex]

      if type(currentMiddleware) == 'nil' then
        return error('can not call "continue" on last middleware of the chain')
      end

      currentMiddleware(req, res, continue)
    end

    continue()
  end
end

local createApp = function()
  local app       = {} -- hash
  app.middlewares = {} -- list
  app.routes      = {} -- list

  -- register a application middleware, ORDER MATTERS!
  app.use = function (middleware)
    table.insert(app.middlewares, middleware)
  end

 -- auxiliary methods for registering new routes
  app.get = function (path, routeMiddlewares)
    router.create(routes, 'GET', path, routeMiddlewares)
  end

  app.post = function (path, routeMiddlewares)
    router.create(routes, 'POST', path, routeMiddlewares)
  end

  app.put = function (path, routeMiddlewares)
    router.create(routes, 'PUT', path, routeMiddlewares)
  end

  app.delete = function (path, routeMiddlewares)
    router.create(routes, 'DELETE', path, routeMiddlewares)
  end 

  -- creates and binds a server to a port
  app.listen = function (port)
    local server = http.createServer(
      requestHandler(app.middlewares, app.routes)
    )

    return server:listen(port)
  end 

  return app
end

return createApp