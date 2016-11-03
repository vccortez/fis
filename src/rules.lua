local propositions = require 'propositions'

local add_antecedent, add_consequent

local rule_mt = {
  __tostring = function(v)
    local s = ('If %s'):format(v.antecedent) .. (' Then %s'):format(v.consequent)
    return s
  end,
}

local function create_rule(weight)
  local rule = {weight = weight or 1.0}

  rule.add_antecedent = add_antecedent(rule)
  rule.add_consequent = add_consequent(rule)

  return setmetatable(rule, rule_mt)
end

function add_antecedent(rule)
  return function(expression)
    propositions.make_expression(expression)

    rule.antecedent = expression

    return rule
  end
end

local cnt_mt = {
  __tostring = function(v)
    local s = ''
    for i, n in ipairs(v) do
      s = s .. ('%s is %s '):format(n[1].name, n[2])
      if i < #v then s = s .. 'and ' end
    end
    return s
  end,
}

function add_consequent(rule)
  return function(outputs)
    rule.consequent = setmetatable(outputs, cnt_mt)

    return rule
  end
end

function build_rule(expression)
  local rule = create_rule()

  rule.add_antecedent(expression)

  rule.Then = rule.add_consequent

  return rule
end

return {
  create_rule = create_rule,
  build_rule  = build_rule,
}
