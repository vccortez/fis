local op = require 'operators'
local util = require 'util'

local EngineFactory = require 'factory'()
local insert_variable

function EngineFactory:build(args)
  args = args or {}
  self.name = args.name or ''
  self.inputs, self.outputs, self.rules = {}, {}, {}
  self.conjunction = args.conjunction or op.tnorms.Min
  self.disjunction = args.disjunction or op.snorms.Max
  self.complement = args.complement or op.complement.Not
  self.implication = args.implication or op.tnorms.Min
  self.aggregation = args.aggregation or op.snorms.Max
  self.defuzzification = args.defuzzification or op.defuzz.centroid
end

function EngineFactory:add_input(variable)
  insert_variable(self.inputs, variable)
  return variable
end

function EngineFactory:add_output(variable)
  insert_variable(self.outputs, variable)
  return variable
end

function EngineFactory:add_rules(rules)
  for i, r in ipairs(rules) do
    table.insert(self.rules, r)
  end
  return rules
end

function EngineFactory:process(crips_inputs)
  local original_output_set, truncated_output_set = {}, {}

  -- bounds crisp inputs to variable range
  for name, value in pairs(crips_inputs) do
    local input = self.inputs[name]
    local lower_bound, upper_bound = input.min, input.max

    crips_inputs[name] = util.bound(value, lower_bound, upper_bound)
  end

  -- calculate the original output sets
  for _, output in ipairs(self.outputs) do
    original_output_set[output.name] = {}

    -- generate the set with each discrete points
    local discrete_set = {}
    for i = 0, output.disc - 1 do
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

  local activation_degree = {}
  for i, rule in ipairs(self.rules) do
    activation_degree[i] = rule.get_activation_degree(crips_inputs, self.conjunction, self.disjunction, self.complement)

    truncated_output_set[i] = rule.get_output_set(activation_degree[i], self.implication, original_output_set)
  end

  --[[
  for i, v in ipairs(truncated_output_set) do
    io.write('\nrule: ' .. i)

    for varn, set in pairs(v) do
      io.write('\nvar name: ' .. varn ..'\n')
      for j, elem in ipairs(set) do
        io.write('#'..j..' = ('..elem[1]..' / '..elem[2]..'), ')
      end
    end
    io.write('\n')
  end
  ]]

  local aggregated = {}
  for _, out in ipairs(self.outputs) do
    -- aggregated[out.name] = aggregate(truncated_output_set, out.name, state.aggregation)
    aggregated[out.name] = {}

    for i = 0, out.disc - 1 do
      aggregated[out.name][i + 1] = { (i * out.step) + out.min, {} }
    end

    for _, set in ipairs(truncated_output_set) do
      if set[out.name] then
        for i, elem in ipairs(set[out.name]) do
          table.insert(aggregated[out.name][i][2], elem[2])
        end
      end
    end

    for i, v in ipairs(aggregated[out.name]) do
      aggregated[out.name][i][2] = util.reduce(self.aggregation, aggregated[out.name][i][2])
    end
  end

  --[[
  for vname, set in pairs(aggregated) do
    io.write('\naggregated set of ' .. vname .. '\n')

    for j, elem in ipairs(set) do
      io.write('#'..j..' = ('..elem[1]..' / '..elem[2]..'), ')
    end
    io.write('\n')
  end
  ]]

  local crisp_outputs = {}
  for key, set in pairs(aggregated) do
    crisp_outputs[key] = self.defuzzification(set)
  end

  return crisp_outputs, aggregated
end

function EngineFactory:__tostring()
  local s = {
    ('fuzzy inference system %q'):format(self.name),
    ('number of inputs: %d'):format(#self.inputs),
  }

  for _, v in ipairs(self.inputs) do
    table.insert(s, ('%s'):format(v))
  end
  table.insert(s, ('number of outputs: %d'):format(#self.outputs))
  for _, v in ipairs(self.outputs) do
    table.insert(s, ('%s'):format(v))
  end
  table.insert(s, ('number of rules: %d'):format(#self.rules))
  for _, v in ipairs(self.rules) do
    table.insert(s, ('%s'):format(v))
  end

  return table.concat(s, '\n')
end

function insert_variable(tabl, variable)
  if tabl[variable.name] then
    local index

    for i, v in ipairs(tabl) do
      if v.name == variable.name then
        index = i
        break
      end
    end

    tabl[index] = variable
    tabl[variable.name] = variable
  else
    table.insert(tabl, variable)
    tabl[variable.name] = variable
  end
end

return EngineFactory
