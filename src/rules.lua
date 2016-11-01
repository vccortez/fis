local propositions = require 'propositions'

local function create_rule(weight)
  local rule = {
    antecedent = {},
    consequent = {},
    weight     = weight,
  }
  
  return rule
end

return {
  create_rule = create_rule,
}
