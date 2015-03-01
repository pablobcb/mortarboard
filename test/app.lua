local bodyparser = require('../lib/middleware/bodyparser')
local raw_body   = require('../lib/middleware/rawbody')
local request    = require('../lib/request')
local response   = require('../lib/response')
local mb         = require('../lib/mortarboard')

local app = mb()

app.use(raw_body)
app.use(function(req, res, done) 
  request(req)
  response(res)
  done()
end)

local m = function(req, res, continue)
  continue()
end


local m2 = function(req, res, continue)
  res.json(req.body)
end

app.use(bodyparser())
app.use(m)
app.use(m2)

--app.get('/teste', {m2, m3, m4})

app.listen(8000)
print('server up!')
