local bodyparser = require('../lib/middleware/bodyparser')
local mb         = require('../lib/mortarboard')

local app = mb()


-- to parse jason and etc
app.use(bodyparser())

app.post('/foo/:a/bar', function(req, res)
  p("path parameteres: " .. req.params.a)

  p('querystring parameters:')
  p(req.query)

  p('raw body:')
  p(req.raw_body)

  p('json body:')
  p(req.body)

  res.json(req.body)
end)


local port = 8000
app.listen(port)
print("[mortarboard]: server listening at http://localhost:" .. port .. "/")