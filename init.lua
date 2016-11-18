local dir, req = (...):match("(.-)[^%.]+$"), require

require = function(path) return req(dir..'src.'..path) end

return require 'fis'
