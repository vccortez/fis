local terms = require 'src.term'

local add_term, evaluate, to_string

local function create_variable(name, min, max, discrete_points)
  local variable = {
    name  = name or '',
    min   = min  or 0.0,
    max   = max  or 10.0,
    terms = {}
  }

  -- the number of discretization points defaults to range
  variable.range = variable.max - variable.min
  variable.disc  = discrete_points or variable.range
  -- discretization step defines the distance between two
  -- points next to each other
  variable.step  = variable.range/variable.disc

  variable.add_term  = add_term(variable)
  variable.evaluate  = evaluate(variable)
  variable.to_string = to_string(variable)

  return variable
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

function to_string(self)
  return function()
    local s = {}

    table.insert(s, ('variable %q'):format(self.name))
    table.insert(s, ('range: [%d-%d]'):format(self.min, self.max))

    for _, v in pairs(self.terms) do table.insert(s, v.to_string()) end

    return table.concat(s, '\n')
  end
end


return {
  create_variable = create_variable,
}
