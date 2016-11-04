local term_mt

local function create_term(name, mf, params)
  local term = {
    name = name or '',
    mf = mf,
    params = params,
  }

  return setmetatable(term, term_mt)
end

term_mt = {
  __tostring = function(v)
    local input = (function()if v.latest_input then return('%.2f'):format(v.latest_input)else return'not set'end end)()
    local value = (function()if v.latest_value then return('%.2f'):format(v.latest_value)else return'not set'end end)()

    local s = {
      ('term %q'):format(v.name),
      ('membership function: %s'):format(v.mf('name')),
      ('parameters: [ %s ]'):format(table.concat(v.params, ', ')),
      ('latest input: %s'):format(input),
      ('latest value: %s'):format(value),
    }

    return table.concat(s, '\n')
  end
}

return {
  create_term = create_term,
}
