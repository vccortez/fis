local function _min_(a, b)
  if a ~= a then return b
  elseif b ~= b then return a
  else return math.min(a, b)
  end
end

local function min(params)
  if #params == 0 then
    return math.huge
  else
    local a = params[1]
    return _min_(a, min({table.unpack(params, 2)}))
  end
end

local function _max_(a, b)
  if a ~= a then return b
  elseif b ~= b then return a
  else return math.max(a, b)
  end
end

local function max(params)
  if #params == 0 then
    return -math.huge
  else
    local a = params[1]
    return _max_(a, max({table.unpack(params, 2)}))
  end
end

local function bound(x, a, b)
  if a > b then a, b = b, a end

  return max({a, min({x, b})})
end

return {
  bound = bound,
  min = min,
  max = max,
}
