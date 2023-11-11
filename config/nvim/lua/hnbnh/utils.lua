return {
  join = function(...)
    local merged = {}
    for _, t in ipairs({ ... }) do
      for _, v in pairs(t) do
        table.insert(merged, v)
      end
    end

    return merged
  end,

  fg = function(name)
    local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
    local fg = hl and (hl.fg or hl.foreground)
    return fg and { fg = string.format("#%06x", fg) }
  end,

  dump = function(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    vim.notify(table.unpack(objects))
  end,

  duplicate = function(s, n)
    local result = ""

    for _ = 1, n do
      result = result .. s
    end

    return result
  end,

  Singleton = function(instance_callback)
    local obj = {}

    function obj.new()
      if obj.instance then
        return obj.instance
      end

      obj.instance = instance_callback()
      return obj.instance
    end

    return obj
  end,
}
