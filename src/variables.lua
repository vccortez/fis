local VariableFactory = require 'factory'()

function VariableFactory:build(name, min, max, discrete_points)
  self.name = name or ''
  self.min = min or 0.0
  self.max = max or 10.0
  self.terms = {}

  self.range = self.max - self.min
  self.disc = discrete_points or self.range + 1
  self.step = self.range / (self.disc - 1)
end

function VariableFactory:add_term(term)
  self.terms[term.name] = term

  return self
end

function VariableFactory:__tostring()
  local s = {
    ('variable %q'):format(self.name),
    ('range: [%d-%d]'):format(self.min, self.max),
  }

  for _, term in pairs(self.terms) do
    table.insert(s, ('%s'):format(term))
  end

  return table.concat(s, '\n')
end

return VariableFactory
