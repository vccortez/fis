local evaluate

-- this proposition metatable will
-- combine propositions into expressions
local prop_mt = {
  -- bitwise and `&`
  __band = function(lhs, rhs)
    return setmetatable({
        category = 'complex',
        lhs = lhs,
        rhs = rhs,
        operator = 'and',
      }, prop_mt)
  end,
  -- bitwise or `|`
  __bor = function(lhs, rhs)
    return setmetatable({
        category = 'complex',
        lhs = lhs,
        rhs = rhs,
        operator = 'or',
      }, prop_mt)
  end,
  -- bitwise not `~`
  __bnot = function(lhs)
    return setmetatable({
        category = 'complex',
        lhs = lhs,
        operator = 'not',
      }, prop_mt)
  end,
  __tostring = function(v)
    if v.category == 'simple' then
      return ('(%s is %s)'):format(v.variable.name, v.term)
    elseif v.operator == 'not' then
      return ('(not %s)'):format(v.lhs)
    else
      return ('(%s %s %s)'):format(v.lhs, v.operator, v.rhs)
    end
  end,
  __metatable = {},
}

local function create_proposition(variable, term)
  local proposition = {
    category = 'simple',
    variable = variable,
    term = term,
  }

  return setmetatable(proposition, prop_mt)
end

local function make_expression(obj)
  return setmetatable(obj, prop_mt)
end

return {
  create_proposition = create_proposition,
  make_expression = make_expression,
}
