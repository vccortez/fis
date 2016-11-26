fis
===

**fis** is a simple **f**uzzy **i**nference **s**ystem library. 
It supports Lua >= **5.3**.

Usage
-----

First require the module to access its core objects:

```lua
local fis = require 'fis.init'

local fn = fis.Membership

local E = fis.Engine
local V = fis.Variables
local T = fis.Terms

local If = fis.Rules.build_rule
local P = fis.Propositions.create_proposition
```

To build a fuzzy inference system, start by creating an `engine` object:

```lua
local engine = E{name = 'inference engine'}
```

Add input and output variables:

```lua
local fuzzy_input = engine:add_input( V('input variable', 0, 10, 101) )
  :add_term(T('input term', fn.trimf, {0, 0, 5}))

local fuzzy_output = engine:add_output( V('output variable', 0, 10, 101) )
  :add_term(T('output term', fn.trapmf, {0, 0, 5, 10}))
```

And finally, reference your variables to create the rules:

```lua
local fuzzy_rules = engine:add_rules{
  If( P(fuzzy_input, 'input term') ).Then{{ fuzzy_output, 'output term' }},
  ...
}
```

License
-------

This software is licensed under [MIT](license).