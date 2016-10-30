local function head(tbl)
  return tbl[1]
end

local function tail(tbl)
  return {table.unpack(tbl, 2)}
end

local function fold(fn, tbl, val)
  for _, v in pairs(tbl) do
    val = fn(val, v)
  end
  return val
end

local function reduce(fn, tbl)
  return fold(fn, tail(tbl), head(tbl))
end

local function minimum(a, b)
  if a ~= a then return b
  elseif b ~= b then return a
  else return math.min(a, b)
  end
end

local function min(...)
  return reduce(minimum, {...})
end

local function maximum(a, b)
  if a ~= a then return b
  elseif b ~= b then return a
  else return math.max(a, b)
  end
end

local function max(...)
  return reduce(maximum, {...})
end

local function bound(x, a, b)
  if a > b then a, b = b, a end

  return max(a, min(x, b))
end

return {
  bound = bound,
  min = min,
  max = max,
  head = head,
  tail = tail,
  reduce = reduce,
}
