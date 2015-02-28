local bodyparser = require('../lib/middleware/bodyparser')
local raw_body = require('../lib/middleware/rawbody')
local request = require('../lib/middleware/request')
local response = require('../lib/middleware/response')
local mb = require('../lib/mortarboard')
local app = mb()

app.use(request)
app.use(response)
app.use(raw_body)

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
