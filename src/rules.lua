local propositions = require 'propositions'

local rule_mt, cnt_mt
local add_antecedent, add_consequent, get_activation_degree, get_output_set

local function create_rule(weight)
  local rule = {weight = weight or 1.0}

  rule.add_antecedent = add_antecedent(rule)
  rule.add_consequent = add_consequent(rule)
  rule.get_activation_degree = get_activation_degree(rule)
  rule.get_output_set = get_output_set(rule)

  return setmetatable(rule, rule_mt)
end

function add_antecedent(rule)
  return function(expression)
    rule.antecedent = expression

    return rule
  end
end

function add_consequent(rule)
  return function(outputs)
    rule.consequent = setmetatable(outputs, cnt_mt)

    return rule
  end
end

function get_activation_degree(rule)
  return function(inputs, And, Or, Not)
    -- evaluates propositions
    local function eval(p)
      if p.category == 'simple' then
        local term = p.variable.terms[p.term]
        term.latest_input = inputs[p.variable.name]
        local result = term.mf(inputs[p.variable.name], term.params)
        term.latest_value = result
        return result
      elseif p.operator == 'not' then
        return Not(eval(p.lhs))
      else
        local lhs, rhs = eval(p.lhs), eval(p.rhs)
        if p.operator == 'and' then
          return And(lhs, rhs)
        else
          return Or(lhs, rhs)
        end
      end
    end

    return eval(rule.antecedent)
  end
end

function get_output_set(self)
  return function(degree, Impl, base_set)
    local outputs = {}

    for _, cons in ipairs(self.consequent) do
      local var, term = table.unpack(cons)
      outputs[var.name] = {}

      for i, elem in ipairs(base_set[var.name][term]) do
        local x, x_degree = table.unpack(elem)

        outputs[var.name][i] = { x, Impl(x_degree, degree) }
      end
    end

    return outputs
  end
end

function build_rule(expression)
  local rule = create_rule()

  rule.add_antecedent(expression)

  rule.Then = rule.add_consequent

  return rule
end

rule_mt = {
  __tostring = function(v)
    local s = ('If %s'):format(v.antecedent) .. (' Then %s'):format(v.consequent)
    return s
  end,
}

cnt_mt = {
  __tostring = function(v)
    local s = ''
    for i, n in ipairs(v) do
      s = s .. ('%s is %s '):format(n[1].name, n[2])
      if i < #v then s = s .. 'and ' end
    end
    return s
  end,
}

return {
  create_rule = create_rule,
  build_rule = build_rule,
}
