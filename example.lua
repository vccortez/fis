-- --------------------------------------------------------
-- runs the classic tipping fuzzy inference system
-- --------------------------------------------------------

local fis = require 'init'

local fn = fis.Membership
local E = fis.Engine
local V = fis.Variables
local T = fis.Terms
local If = fis.Rules.build_rule
local P = fis.Propositions.create_proposition

local engine = E{name = 'tipper'}

local service = engine:add_input(V('service', 0., 10., 11))
  :add_term(T('poor', fn.trimf, {0., 0., 5.}))
  :add_term(T('good', fn.trimf, {0., 5., 10.}))
  :add_term(T('excellent', fn.trimf, {5., 10., 10.}))

local food = engine:add_input(V('food', 0., 10., 11))
  :add_term(T('rancid', fn.trimf, {0., 0., 5.}))
  :add_term(T('average', fn.trimf, {0., 5., 10.}))
  :add_term(T('delicious', fn.trimf, {5., 10., 10.}))

local tip = engine:add_output(V('tip', 0., 25., 26))
  :add_term(T('cheap', fn.trimf, {0., 0., 13.}))
  :add_term(T('average', fn.trimf, {0., 13., 25.}))
  :add_term(T('generous', fn.trimf, {13., 25., 25.}))

local rules = engine:add_rules{
  If( P(service, 'poor') & P(food, 'rancid') ).Then{{tip, 'cheap'}},
  If( P(service, 'good') ).Then{{tip, 'average'}},
  If( P(service, 'excellent') | P(food, 'delicious') ).Then{{tip, 'generous'}}
}

print'type service input [0-10]'
local serv = tonumber(io.read())
print'type food input [0-10]'
local food = tonumber(io.read())
local outputs = engine:process{service = serv, food = food}

for k, v in pairs(outputs) do
  print(k, v)
end

print(engine)
