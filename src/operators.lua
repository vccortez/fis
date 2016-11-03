local util = require 'util'

local tnorms, snorms, complement = {}, {}, {}

function tnorms.Min(a, b)
  return util.minimum(a, b)
end

function snorms.Max(a, b)
  return util.maximum(a, b)
end

function complement.Not(a)
  return 1.0 - a
end

return {tnorms, snorms, complement}
