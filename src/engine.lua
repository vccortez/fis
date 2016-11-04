local variables = require 'variables'
local rules = require 'rules'

local function create_engine(params)
  local name, cnj, dsj, neg = table.unpack(params)
  -- initialize internal state
  local state = {
    name = name or '',
    inputs = {},
    outputs = {},
    rules = {},
    ops = {cnj, dsj, neg},
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
    return function(name, min, max, disc)
      local variable = variables.create_variable(name, min, max, disc)

      insert_variable(variable_table, variable)

      return variable
    end
  end

  local function add_rules(rules)
    for i, v in ipairs(rules) do
      table.insert(state.rules, v)
    end

    return rules
  end

  local engine_mt = {
    __tostring = function(_)
      local s = {
        ('fuzzy inference system %q'):format(state.name),
        ('number of inputs: %d'):format(#state.inputs),
      }
      for _, v in ipairs(state.inputs) do
        table.insert(s, ('%s'):format(v))
      end
      table.insert(s, ('number of outputs: %d'):format(#state.outputs))
      for _, v in ipairs(state.outputs) do
        table.insert(s, ('%s'):format(v))
      end
      table.insert(s, ('number of rules: %d'):format(#state.rules))
      for _, v in ipairs(state.rules) do
        table.insert(s, ('%s'):format(v))
      end

      return table.concat(s, '\n')
    end,
  }

  return setmetatable({
      add_input = add_variable(state.inputs),
      add_output = add_variable(state.outputs),
      add_rules = add_rules,
    }, engine_mt)
end

return {
  create_engine = create_engine,
}
