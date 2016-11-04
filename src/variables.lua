local terms = require 'terms'

local add_term, evaluate, variable_mt

local function create_variable(name, min, max, discrete_points)
  local variable = {
    name = name or '',
    min = min or 0.0,
    max = max or 10.0,
    terms = {}
  }

  -- the number of discretization points defaults to range
  variable.range = variable.max - variable.min
  variable.disc = discrete_points or variable.range
  -- discretization step defines the distance between two
  -- points next to each other
  variable.step = variable.range/variable.disc

  variable.add_term = add_term(variable)
  variable.evaluate = evaluate(variable)

  return setmetatable(variable, variable_mt)
end

function add_term(self)
  return function(name, mf, params)
    local term = terms.create_term(name, mf, params)

    self.terms[term.name] = term

    return self
  end
end

function evaluate(self)
  return function(input)
    local values = {}

    for name, term in pairs(self.terms) do
      local value = term.mf(input, term.params)

      term.latest_input = input
      term.latest_value = value

      table.insert(values, value)
      values[name] = value
    end

    return values
  end
end

variable_mt = {
  __tostring = function(v)
    local s = {
      ('variable %q'):format(v.name),
      ('range: [%d-%d]'):format(v.min, v.max)
    }

    for _, v in pairs(v.terms) do
      table.insert(s, ('%s'):format(v))
    end

    return table.concat(s, '\n')
  end,
}

return {
  create_variable = create_variable,
}
