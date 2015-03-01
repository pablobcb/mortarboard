local bodyparser = require('../lib/middleware/bodyparser')
local raw_body   = require('../lib/middleware/rawbody')
local mb         = require('../lib/mortarboard')

local app = mb()

app.use(raw_body)

local m = function(req, res, continue)
  p(req)
  continue()
end

app.use(bodyparser())
app.use(m)

app.post('/foo/:p1/bar/:jeff/:koilos', function(req, res)
  res.json(req.body)
end)

app.get('/jeff',function(req, res)
  p(req.query)
  res.send('UHUL')
end)

local port = 8000
app.listen(port)
print("[mortarboard]: server listening at http://localhost:" .. port .. "/")