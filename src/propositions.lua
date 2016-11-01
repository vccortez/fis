local evaluate

local function create_simple_proposition(variable, term, is_negative)
  local proposition = {
    category = 'simple',
    variable = variable,
    term     = term,
    operator = is_negative and true,
  }

  proposition.evaluate = evaluate(proposition)
end

function evaluate(proposition)
  return function(input)
    local value = proposition.variable.evaluate(input, proposition.term)

    if proposition.operator then
      -- apply complement operator to value
    end

    return value
  end
end

return {
  create_simple_proposition = create_simple_proposition,
}
