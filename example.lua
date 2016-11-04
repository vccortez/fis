-- --------------------------------------------------------
-- runs the classic tipping fuzzy inference system
-- --------------------------------------------------------

local fis = require 'init'
local fn = fis.mfn
local op = fis.ops
local If = fis.rules.build_rule
local P = fis.props.create_proposition

local engine = fis.create_engine{name = 'tipper'}

local service = engine.add_input('service', 0., 10., 11)
  .add_term('poor', fn.trimf, {0., 0., 5.})
  .add_term('good', fn.trimf, {0., 5., 10.})
  .add_term('excellent', fn.trimf, {5., 10., 10.})

local food = engine.add_input('food', 0., 10., 11)
  .add_term('rancid', fn.trimf, {0., 0., 5.})
  .add_term('average', fn.trimf, {0., 5., 10.})
  .add_term('delicious', fn.trimf, {5., 10., 10.})

local tip = engine.add_output('tip', 0., 25., 26)
  .add_term('cheap', fn.trimf, {0., 0., 13.})
  .add_term('average', fn.trimf, {0., 13., 25.})
  .add_term('generous', fn.trimf, {13., 25., 25.})

local rules = engine.add_rules{
  If( P(service, 'poor') & P(food, 'rancid') ).Then{{tip, 'cheap'}},
  If( P(service, 'good') ).Then{{tip, 'average'}},
  If( P(service, 'excellent') | P(food, 'delicious') ).Then{{tip, 'generous'}}
}

print'type service input [0-10]'
local serv = tonumber(io.read())
print'type food input [0-10]'
local food = tonumber(io.read())
local outputs = engine.process{service = serv, food = food}

for k, v in pairs(outputs) do
  print(k, v)
end

--[[
io.write'type a value to evaluate service: '
local i = tonumber(io.read())

for k, v in pairs(service.evaluate(i)) do
  if type(k) == 'string' then
    print(string.format('term %s = %.3f', k, v))
  end
end

-- food:evaluate(10)
]]
