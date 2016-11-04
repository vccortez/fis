local variables = require 'variables'
local rules = require 'rules'
local op = require 'operators'

local function create_engine(params)
  -- initialize internal state with default values
  local state = {
    name = '',
    inputs = {},
    outputs = {},
    rules = {},
    conjunction = op.tnorms.Min,
    disjunction = op.snorms.Max,
    complement = op.complement.Not,
  }

  -- verify parameters and overwrite state
  if params then
    local keys = {'name', 'conjunction', 'disjunction', 'complement', 'implication', 'aggregation'}

    for _, key in ipairs(keys) do
      if params[key] then
        state[key] = params[key]
      end
    end
  end

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

  local function process(crips_inputs)
    local original_output_set, truncated_output_set = {}, {}

    -- calculate the original output sets
    for _, output in ipairs(state.outputs) do
      original_output_set[output.name] = {}

      -- generate the set with each discrete points
      local discrete_set = {}
      for i = 0, v.disc - 1 do
        discrete_set[i + 1] = (i * output.step) + output.min
      end

      -- generate each term's fuzzy set
      for term_name, term in pairs(output.terms) do
        local term_set = {}

        for i, val in ipairs(discrete_set) do
          term_set[i] = { val, term.mf(val, term.params) }
        end

        original_output_set[output.name][term_name] = term_set
      end
    end

    for i, rule in ipairs(state.rules) do
      activation_degree[i] = rule.get_activation_degree(crips_inputs, state.conjunction, state.disjunction, state.complement)

      truncated_output_set[i] = rule.get_output_set(activation_degree[i], state.implication, original_output_set)
    end

    local aggregated = {}
    for i, out in ipairs(state.outputs) do
      aggregated[out.name] = aggregate(truncated_output_set, out.name, state.aggregation)
    end

    local crisp_outputs = {}
    for key, set in pairs(aggregated) do
      crisp_outputs[key] = defuzzify(set, state.defuzzification)
    end

    return crisp_outputs
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
      process = process,
    }, engine_mt)
end

return {
  create_engine = create_engine,
}
