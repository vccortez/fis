local propositions = require 'propositions'

local add_antecedent

local function create_rule(weight)
  local rule = {weight = weight or 1.0}

  rule.add_antecedent = add_antecedent(rule)

  return rule
end

function add_antecedent(rule)
  return function(expression)
    rule.antecedent = expression

    return rule
  end
end

return {
  create_rule = create_rule,
}
