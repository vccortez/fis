local util = require 'util'

local tnorm, snorm, complement = {}, {}, {}

function tnorm.Min(a, b)
  return util.minimum(a, b)
end

function snorm.Max(a, b)
  return util.maximum(a, b)
end

function complement.Not(a)
  return 1.0 - a
end

return {
  tnorms = tnorm,
  snorms = snorm,
  complement = complement,
}
