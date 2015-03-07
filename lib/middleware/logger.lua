return function (req, res, done)
  done()
  -- TODO: colors
  print(string.format("%s %s %s - %sb"
  , req.method
  , req.path
  , res.statusCode
  , res.headers['content-length']
  ))
end