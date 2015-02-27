require('./util')

local http   = require('http')
local router = require('./router')

local requestHandler = function (app_middlewares, routes)
  return function(req, res)
    -- list of all middlewares that will
    -- sequentially compute the request
    local request_chain = {}
    request_chain = table.concatenate(request_chain, app_middlewares)

    local current_middleware_index = 0

    -- function that will consume asynchronously 
    -- the middlewares of the request chain
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

local createApp = function()
  local app       = {} -- hash
  app.middlewares = {} -- list
  app.routes      = {} -- list

  -- register a application middleware, ORDER MATTERS!
  app.use = function (middleware)
    table.insert(app.middlewares, middleware)
  end

 -- auxiliary methods for registering new routes
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