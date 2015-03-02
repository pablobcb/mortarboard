local bodyparser = require('../lib/middleware/bodyparser')
local mb         = require('../lib/mortarboard')

local app = mb()


app.use(bodyparser())

app.post('/foo/:p1/bar/:jeff/:koilos', function(req, res)
  res.json(req.body)
end)

app.get('/jeff',function(req, res)
  res.send('UHUL')
end)

local port = 8000
app.listen(port)
print("[mortarboard]: server listening at http://localhost:" .. port .. "/")