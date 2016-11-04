local util = require 'util'

local tnorm, snorm, complement, defuzzification = {}, {}, {}, {}

function tnorm.Min(a, b)
  return util.minimum(a, b)
end

function snorm.Max(a, b)
  return util.maximum(a, b)
end

function complement.Not(a)
  return 1.0 - a
end

function defuzzification.centroid(set)
  local n, d = 0., 0.

  for _, v in ipairs(set) do
    n = n + v[1] * v[2]
    d = d + v[2]
  end

  if d == 0 then return 0 end

  return n/d
end

return {
  tnorms = tnorm,
  snorms = snorm,
  complement = complement,
  defuzz = defuzzification,
}
