local to_string

local function create_term(name, mf, params)
  local term = {
    name   = name or '',
    mf     = mf,
    params = params,
  }

  term.to_string = to_string(term)

  return term
end

function to_string(self)
  return function()
    local s = {}

    local input = (function()if self.latest_input then return('%.2f'):format(self.latest_input)else return'not set'end end)()
    local value = (function()if self.latest_value then return('%.2f'):format(self.latest_value)else return'not set'end end)()

    table.insert(s, ('term %q'):format(self.name))
    table.insert(s, ('membership function: %s'):format(self.mf('name')))
    table.insert(s, ('parameters: %s'):format(table.concat(self.params, ', ')))
    table.insert(s, ('latest input: %s'):format(input))
    table.insert(s, ('latest value: %s'):format(value))

    return table.concat(s, '\n')
  end
end


return {
  create_term = create_term,
}
