-- --------------------------------------------------------
-- runs the classic tipping fuzzy inference system
-- --------------------------------------------------------

local flot = require 'flot'

local fis = require 'init'
local fn = fis.Membership
local E = fis.Engine.create
local V = fis.Variables.create
local T = fis.Terms.create
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

local tip = engine:add_output(V('tip', 0., 25., 101))
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
local outputs, set = engine:process{service = serv, food = food}

local p = flot.Plot {
  doctitle = 'Tipper Example',
  filename = 'tipper-example',
  legend = { position = 'se' },
  yaxis = { min = 0.0, max = 1.0 },
}

p:add_series(tip.name, set[tip.name])

flot.render(p)
