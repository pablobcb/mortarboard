function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

function table.print (t)
  if not t then
    t = {}
  end

  print(table.tostring(t))
end

function table.isarray(tbl)
  local numKeys = 0
  for _, _ in pairs(tbl) do
      numKeys = numKeys+1
  end

  local numIndices = 0
  for _, _ in ipairs(tbl) do
      numIndices = numIndices+1
  end

  return numKeys == numIndices
end

function table.concatenate(t1, t2)
  local out = {}

  if (table.isarray(t1) and table.isarray(t2)) then
    for i,v in ipairs(t1) do
      out[#out + 1] = t1[i]
    end

    for i,v in ipairs(t2) do
      out[#out + 1] = t2[i]
    end
  end

  return out
end

function table.flatten(t1)
  local flat = {}
  for i = 1, #t1 do
    if type(t1[i]) == 'table' then
      local inner_flatten = table.flatten(t1[i])
      flat = table.concatenate(flat, inner_flatten)
    else
      flat[#flat + 1] = t1[i]
    end
  end
  return flat
end

-- applys f to each value of the array
function table.each(t1, f)
  for _, v in ipairs(t1) do
    f(v)
  end
end

-- applys f to each value of the array,
-- storing its return in a list and returning it
function table.map(t1, f)
  local out = {}

  for i, v in ipairs(t1) do
    out[i] = f(v)
  end

  return out
end

function table.filter(t, predicate)
  local out = {}
 
  for _, v in ipairs(t) do
    if predicate(v) then
      out[#out + 1] = v 
    end
  end
 
  return out
end

-- return the FIRST who satisfies the predicate
function table.find(t, predicate)
  for _, v in ipairs(t) do
    if predicate(v) then 
      return v
    end
  end
end

-- splits a string with a given separator
string.split = function (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end

  local t = {} 
  local i = 1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end

  return t
end
--TODO: create assertype function