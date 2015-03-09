local bodyparser = require('../lib/middleware/bodyparser')
local mb         = require('../lib/mortarboard')

local app = mb()


-- to parse json and etc
app.use(bodyparser())

app.post('/foo/:a/bar', function(req, res)
  print("path parameteres: " .. req.params.a)

  print('querystring parameters:')
  print(req.query)

  print('raw body:')
  print(req.raw_body)

  print('json body:')
  print(req.body)

end) 

local port = 8000
app.listen(port)
print("[mortarboard]: server listening at http://localhost:" .. port .. "/")