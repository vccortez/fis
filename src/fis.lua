local u = require 'util'

function create_engine(name)
  local this = {
    name    = name or '',
    inputs  = {},
    outputs = {},
  }

  local function term_to_string(self)
    local str = {}

    local input = (function()if self.latest_input then return('%.2f'):format(self.latest_input)else return'not set'end end)()
    local value = (function()if self.latest_value then return('%.2f'):format(self.latest_value)else return'not set'end end)()

    table.insert(str, ('term %q'):format(self.name))
    table.insert(str, ('membership function: %s'):format(self.mf('name')))
    table.insert(str, ('parameters: %s'):format(table.concat(self.params, ', ')))
    table.insert(str, ('latest input: %s'):format(input))
    table.insert(str, ('latest value: %s'):format(value))

    return table.concat(str, '\n')
  end

  local function variable_add_term(variable, name, mf, params)
    local term  = {}

    term.name   = name
    term.mf     = mf
    term.params = params

    term.to_string = term_to_string

    variable.terms[term.name] = term

    return variable
  end

  local function variable_evaluate(variable, input)
    local values = {}

    for name, term in pairs(variable.terms) do
      local value = term.mf(input, term.params)

      term.latest_input = input
      term.latest_value = value

      table.insert(values, value)
      values[name] = value
    end

    return values
  end

  local function variable_to_string(self)
    local str = {}

    table.insert(str, ('variable %q'):format(self.name))
    table.insert(str, ('range: [%d-%d]'):format(self.min, self.max))
    for _, v in pairs(self.terms) do table.insert(str, v:to_string()) end

    return table.concat(str, '\n')
  end

  local function engine_insert_variable(variable_table, variable)
    if variable_table[variable.name] then
      local index

      for i, v in ipairs(variable_table) do
        if v.name == variable.name then
          index = i
          break
        end
      end

      variable_table[index] = variable
      variable_table[variable.name] = variable
    else
      table.insert(variable_table, variable)
      variable_table[variable.name] = variable
    end
  end

  local function engine_add_variable(variable_table)
    return function(name, min, max)
      local variable = {}

      variable.name  = name
      variable.min   = min
      variable.max   = max
      variable.terms = {}

      engine_insert_variable(variable_table, variable)

      variable.add_term  = variable_add_term
      variable.evaluate  = variable_evaluate
      variable.to_string = variable_to_string

      return variable
    end
  end

  local function engine_to_string()
    local str = {}

    table.insert(str, ('fuzzy inference system %q'):format(this.name))
    table.insert(str, ('number of inputs: %s'):format(#this.inputs))
    for _, v in ipairs(this.inputs) do table.insert(str, v:to_string()) end
    table.insert(str, ('number of outputs: %s'):format(#this.outputs))
    for _, v in ipairs(this.outputs) do table.insert(str, v:to_string()) end

    return table.concat(str, '\n')
  end

  return {
    add_input  = engine_add_variable(this.inputs),
    add_output = engine_add_variable(this.outputs),
    to_string  = engine_to_string,
  }
end

return {
  create_engine = create_engine,
}
