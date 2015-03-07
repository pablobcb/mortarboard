return function (req, res, done)
  done()
  -- log after everything is done
  -- POST /api/lot/9/bid 201 23ms - 126b
  print(string.format("%s %s %s - %sb"
  , req.method
  , req.path
  , res.statusCode
  , res.headers['content-length']
  ))
end