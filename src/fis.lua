local variables = require 'src.variable'

local function create_engine(name)
  local state = {
    name    = name or '',
    inputs  = {},
    outputs = {},
    rules   = {},
  }

  local function insert_variable(variable_table, variable)
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

  local function add_variable(variable_table)
    return function(name, min, max)
      local variable = variables.create_variable(name, min, max)

      insert_variable(variable_table, variable)

      return variable
    end
  end

  local function to_string()
    local str = {}

    table.insert(str, ('fuzzy inference system %q'):format(state.name))
    table.insert(str, ('number of inputs: %s'):format(#state.inputs))
    for _, v in ipairs(state.inputs) do table.insert(str, v.to_string()) end
    table.insert(str, ('number of outputs: %s'):format(#state.outputs))
    for _, v in ipairs(state.outputs) do table.insert(str, v.to_string()) end

    return table.concat(str, '\n')
  end

  return {
    add_input  = add_variable(state.inputs),
    add_output = add_variable(state.outputs),
    to_string  = to_string,
  }
end

return {
  create_engine = create_engine,
}
