function create_engine()
  local this = {
    inputs  = {},
    outputs = {},
  }

  local function variable_add_term(variable_table)
    return function(self, name, mf, params)
      local input = self
      local term  = {}

      term.name   = name
      term.mf     = mf
      term.params = params

      variable_table.terms[term.name] = term

      return term
    end
  end

  local function variable_list_terms(self)
    local input = self

    for _, i in pairs(kind) do
      io.write(i.name .. '\n')
    end
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

      var.addTerm   = variable_add_term(variable_table)
      var.listTerms = variable_list_terms

      return var
    end
  end

  local function engine_list_variables(variable_table)
    return function()
      for _, i in ipairs(variable_table) do
        io.write(i.name .. '\n')
      end
    end
  end

  return {
    addInput = engine_add_variable(this.inputs),
    addOutput = engine_add_variable(this.outputs),
    listInputs = engine_list_variables(this.inputs),
    listOutputs = engine_list_variables(this.outputs),
  }
end

return {
  createEngine = create_engine,
}
