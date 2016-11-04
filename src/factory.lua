local function factory(proto_chain)
  local proto = {}

  proto.__index = proto

  function proto.create(...)
    local instance = setmetatable({}, proto)

    if instance.build then
      instance:build(...)
    end

    return instance
  end

  return setmetatable(proto, proto_chain)
end

return factory
