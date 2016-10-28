function create_engine()
  local this = {
    inputs  = {},
    outputs = {},
  }

  local function term_to_string(self)
    local str = {}

    table.insert(str, ('  - term: %s'):format(self.name))

    return table.concat(str, '\n')
  end

  local function variable_add_term(self, name, mf, params)
    local input = self
    local term  = {}

    term.name   = name
    term.mf     = mf
    term.params = params
    term.toString = term_to_string

    input.terms[term.name] = term

    return input
  end

  local function variable_to_string(self)
    local str = {}

    table.insert(str, (' - input variable %q'):format(self.name))
    table.insert(str, ('  - range [%d-%d]'):format(self.min, self.max))
    for _, v in pairs(self.terms) do table.insert(str, v:toString()) end

    return table.concat(str, '\n')
  end

  local function engine_add_variable(variable_table)
    return function(name, min, max)
      local var = {}

      var.name  = name
      var.min   = min
      var.max   = max
      var.terms = {}

      table.insert(variable_table, var)
      variable_table[var.name] = var

      var.addTerm  = variable_add_term
      var.toString = variable_to_string

      return var
    end
  end

  local function engine_to_string()
    local str = {}

    table.insert(str, '- fuzzy inference system')
    table.insert(str, (' - number of inputs:  %s'):format(#this.inputs))
    table.insert(str, (' - number of outputs: %s'):format(#this.outputs))
    for _, v in ipairs(this.inputs) do table.insert(str, v:toString()) end
    for _, v in ipairs(this.outputs) do table.insert(str, v:toString()) end

    return table.concat(str, '\n')
  end

  return {
    addInput = engine_add_variable(this.inputs),
    addOutput = engine_add_variable(this.outputs),
    toString = engine_to_string,
  }
end

return {
  createEngine = create_engine,
}
