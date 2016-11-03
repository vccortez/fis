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

return {
  create_proposition = create_proposition,
}
