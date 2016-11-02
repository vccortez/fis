local req = require

require = function(path) return req('src.' .. path) end

return require 'fis'
