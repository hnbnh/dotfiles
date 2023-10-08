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

M.toggle_spell = function()
  vim.opt.spell = not (vim.opt.spell:get())
end

M.fg = function(name)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

M.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  vim.notify(table.unpack(objects))
end

M.duplicate = function(s, n)
  local result = ""

  for _ = 1, n do
    result = result .. s
  end

  return result
end

return M
