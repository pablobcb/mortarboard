local parse_request = require('../lib/request')
local tests = {}

-- hostname
local hostname = '123.142.23.141'
local port = '8080'
local url = '/breno/419/magro?jerry=jenkins&att=foo%20bar'

local req = {
  headers = { 
    host  = hostname .. port,
    breno = 'magro'
  },

  url = url,
  req.socket = { options = nil },
}

local parsed_req = request(req)

local testHostname = function(req)
  assert(req.hostname == hostname)
end

local testPort = function(req)
  assert(req.port == port)
end

local testOriginalUrl = function(req)
  assert(req.original_url == url)
end

local testPath = function(req)
  assert(req.path == '/breno/419/magro')
end

-- TODO: test with url without qs params
local testQuerystring = function(req)
  assert(req.query.jerry == 'jenkins')
  assert(req.query.att == 'foo bar')
end

-- TODO: test https
local testIsHttp = function(req)
  assert(req.protocol == 'http')
end

-- TODO: test secure true
local testIsSecure = function(req)
  assert(req.secure == 'false')
end

-- TODO: test nil header
-- TODO: test inexistent header
local testGetHeader = function(req)
  assert(req.get('breno') == 'magro')
end

-- TODO: test path without params
local testParsePrams = function(req)
  req._parseParams('/breno/:foo/magro')
  assert(req.params.foo == '419')
end

