local TermFactory = require 'factory'()

function TermFactory:build(name, mf, args)
  self.name = name or ''
  self.mf = mf
  self.params = args
end

function TermFactory:__tostring()
  local input = (function()if self.latest_input then return('%.2f'):format(self.latest_input)else return'not set'end end)()

  local value = (function()if self.latest_value then return('%.2f'):format(self.latest_value)else return'not set'end end)()

  local s = {
    ('term %q'):format(self.name),
    ('membership function: %s'):format(self.mf('name')),
    ('parameters: [ %s ]'):format(table.concat(self.params, ', ')),
    ('latest input: %s'):format(input),
    ('latest value: %s'):format(value),
  }

  return table.concat(s, '\n')
end

return TermFactory
