local function factory(proto_chain)
  local proto, base = {}, {}

  proto.__index = proto

  function proto.create(...)
    local instance = setmetatable({}, proto)

    if instance.build then
      instance:build(...)
    end

    return instance
  end

  function base.__call(_, ...)
    return proto.create(...)
  end

  setmetatable(base, proto_chain)

  return setmetatable(proto, base)
end

return factory
