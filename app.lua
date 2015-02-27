local mb = require('./src/mortarboard')
local app = mb()

local m1 = function(req, res, continue)
  res:write('I am middleware1!\n')
  continue()
end

local m2 = function(req, res, continue)
  res:write('I am middleware2!\n')
  continue()
end

local m3 = function(req, res, continue)
  res:write('I am middleware3!\n')
  continue()
end

local m4 = function(req, res, continue)
  res:finish('I am middleware4!\n')
end

app.use(m1)
app.use(m2)
app.use(m3)
app.use(m4)

--app.get('/teste', {m2, m3, m4})

app.listen(8000)
print('server up!')
