local M = {}

-- HACK: https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
table.unpack = table.unpack or unpack -- Lua 5.1 compatibility

M.join = function(...)
  local merged = {}
  for _, t in ipairs({ ... }) do
    for _, v in pairs(t) do
      table.insert(merged, v)
    end
  end

  return merged
end

M.bind = function(f, args)
  return function()
    if args ~= nil then
      return f(table.unpack(args))
    end
    return f()
  end
end

M.toggle_spell = function()
  vim.opt.spell = not (vim.opt.spell:get())
end

return M
