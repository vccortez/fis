-- --------------------------------------------------------
-- runs the classic tipper fuzzy inference system
-- --------------------------------------------------------


local fis = require 'init'
local fn  = fis.mfn

local engine = fis.create_engine('tipper')

local service = engine.add_input('service', 0., 10.)
  .add_term('poor', fn.gaussmf, {1.5, 0.})
  .add_term('good', fn.gaussmf, {1.5, 5.})
  .add_term('excellent', fn.gaussmf, {1.5, 10.})

local food = engine.add_input('food', 0., 10.)
  .add_term('rancid', fn.trapmf, {0., 0., 1., 3.})
  .add_term('delicious', fn.trapmf, {7., 9., 10., 10.})

local tip = engine.add_output('tip', 0., 30.)
  .add_term('cheap', fn.trimf, {0., 5., 10.})
  .add_term('average', fn.trimf, {10., 15., 20.})
  .add_term('generous', fn.trimf, {20., 25., 30.})

io.write'type a value to evaluate service: '
local i = tonumber(io.read())

for k, v in pairs(service.evaluate(i)) do
  if type(k) == 'string' then
    print(string.format('term %s = %.3f', k, v))
  end
end

-- food:evaluate(10)

-- print(engine.to_string())
