local M = {}

M.setup = function()
  local conditions = require("heirline.conditions")
  local utils = require("heirline.utils")
  local ghl = utils.get_highlight

  require("heirline").load_colors({
    bright_bg = ghl("Folded").bg,
    bright_fg = ghl("Folded").fg,
    red = ghl("DiagnosticError").fg,
    dark_red = ghl("DiffDelete").bg,
    green = ghl("String").fg,
    blue = ghl("Function").fg,
    gray = ghl("NonText").fg,
    orange = ghl("Constant").fg,
    purple = ghl("Statement").fg,
    cyan = ghl("Special").fg,
    diag_warn = ghl("DiagnosticWarn").fg,
    diag_error = ghl("DiagnosticError").fg,
    diag_hint = ghl("DiagnosticHint").fg,
    diag_info = ghl("DiagnosticInfo").fg,
    git_del = ghl("diffDeleted").fg,
    git_add = ghl("diffAdded").fg,
    git_change = ghl("diffChanged").fg,
  })

  local Align = { provider = "%=" }
  local Space = { provider = " " }

  local ViMode = {
    init = function(self)
      self.mode = vim.fn.mode(1) -- :h mode()
      if not self.once then
        vim.api.nvim_create_autocmd("ModeChanged", {
          pattern = "*:*o",
          command = "redrawstatus",
        })
        self.once = true
      end
    end,
    static = {
      mode_names = {
        n = "N",
        no = "N?",
        nov = "N?",
        noV = "N?",
        ["no\22"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        ["\22"] = "^V",
        ["\22s"] = "^V",
        s = "S",
        S = "S_",
        ["\19"] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
    },
    provider = function(self)
      return " %2(" .. self.mode_names[self.mode] .. "%)"
    end,
    hl = function(self)
      return { fg = self:mode_color(), bold = true }
    end,
    update = { "ModeChanged" },
  }
  ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })

  local FileNameBlock = {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
  }

  local FileIcon = {
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
      return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end,
  }

  local FileName = {
    init = function(self)
      self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
      if self.lfilename == "" then
        return "[No Name]"
      end
      if not conditions.width_percent_below(#self.lfilename, 0.27) then
        self.lfilename = vim.fn.pathshorten(self.lfilename)
      end
    end,
    hl = { fg = ghl("Directory").fg },
    flexible = 2,
    {
      provider = function(self)
        return self.lfilename
      end,
    },
    {
      provider = function(self)
        return vim.fn.pathshorten(self.lfilename)
      end,
    },
  }

  local FileFlags = {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = "●",
      hl = { fg = "green" },
    },
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = "",
      hl = { fg = "orange" },
    },
  }

  local FileNameModifer = {
    hl = function()
      if vim.bo.modified then
        return { fg = "cyan", bold = true, force = true }
      end
    end,
  }

  FileNameBlock =
    utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifer, FileName), Space, table.unpack(FileFlags))

  local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = " %1(%l/%1L%):  %c %P",
    hl = function()
      return { fg = "orange", bold = true }
    end,
  }
  Ruler = utils.surround({ "", "" }, "bright_bg", { Ruler })

  local ScrollBar = {
    static = {
      sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
    },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
      return string.rep(self.sbar[i], 2)
    end,
    hl = { fg = "blue", bg = "bright_bg" },
  }

  local LSPActive = {
    condition = conditions.lsp_attached,
    update = { "LspAttach", "LspDetach", "WinEnter" },

    provider = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return " [" .. table.concat(names, " ") .. "]"
    end,
    hl = { fg = "green", bold = true },
  }

  local Diagnostics = {
    condition = conditions.has_diagnostics,
    update = { "DiagnosticChanged", "BufEnter" },
    static = {
      error_icon = " ", -- xf659
      warn_icon = " ", -- xf529
      info_icon = " ", -- xf7fc
      hint_icon = " ", -- xf835
    },

    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    {
      provider = function(self)
        return self.errors > 0 and (self.error_icon .. self.errors .. " ")
      end,
      hl = "DiagnosticError",
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
      end,
      hl = "DiagnosticWarn",
    },
    {
      provider = function(self)
        return self.info > 0 and (self.info_icon .. self.info .. " ")
      end,
      hl = "DiagnosticInfo",
    },
    {
      provider = function(self)
        return self.hints > 0 and (self.hint_icon .. self.hints)
      end,
      hl = "DiagnosticHint",
    },
  }

  local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    hl = { fg = "orange" },

    {
      provider = function(self)
        return " " .. self.status_dict.head
      end,
      hl = { bold = true },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = " (",
      hl = { bold = true },
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ("  " .. count)
      end,
      hl = { fg = "git_add", bold = true },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ("  " .. count)
      end,
      hl = { fg = "git_del", bold = true },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and (" 柳" .. count)
      end,
      hl = { fg = "git_change", bold = true },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = " )",
      hl = { bold = true },
    },
  }

  local DefaultStatusline = {
    ViMode,
    Space,
    Git,
    Space,
    FileNameBlock,
    { provider = "%<" },
    Space,
    Diagnostics,
    Align,
    LSPActive,
    Space,
    Ruler,
    Space,
    ScrollBar,
  }

  local InactiveStatusline = {
    condition = conditions.is_not_active,
    { hl = { bg = "gray", fg = "gray", force = true } },
    FileNameBlock,
  }

  local SpecialStatusline = {
    condition = function()
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      })
    end,
    { provider = "%q" },
  }

  local StatusLines = {
    hl = function()
      return conditions.is_active() and "StatusLine" or "StatusLineNC"
    end,

    static = {
      mode_colors = {
        n = "red",
        i = "green",
        v = "cyan",
        V = "cyan",
        ["\22"] = "cyan", -- this is an actual ^V, type <C-v><C-v> in insert mode
        c = "orange",
        s = "purple",
        S = "purple",
        ["\19"] = "purple", -- this is an actual ^S, type <C-v><C-s> in insert mode
        R = "orange",
        r = "orange",
        ["!"] = "red",
        t = "green",
      },
      mode_color = function(self)
        local mode = conditions.is_active() and vim.fn.mode() or "n"
        return self.mode_colors[mode]
      end,
    },

    fallthrough = false,

    SpecialStatusline,
    InactiveStatusline,
    DefaultStatusline,
  }

  local TablineBufnr = {
    provider = function(self)
      return tostring(self.bufnr) .. ". "
    end,
    hl = "Comment",
  }

  local TablineFileName = {
    provider = function(self)
      local filename = self.filename
      filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
      return filename
    end,
    hl = function(self)
      return { bold = self.is_active or self.is_visible, italic = true }
    end,
  }

  local TablineFileFlags = {
    {
      condition = function(self)
        return vim.api.nvim_buf_get_option(self.bufnr, "modified")
      end,
      provider = " ● ",
      hl = { fg = "green" },
    },
    {
      condition = function(self)
        return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
          or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
      end,
      provider = "  ",
      hl = { fg = "orange" },
    },
  }

  local TablineFileNameBlock = {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
    hl = function(self)
      if self.is_active then
        return "TabLineSel"
      elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
        return { fg = "gray" }
      else
        return "TabLine"
      end
    end,
    TablineBufnr,
    FileIcon,
    TablineFileName,
    TablineFileFlags,
  }

  local TablineCloseButton = {
    condition = function(self)
      return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
    end,
    Space,
    { -- ✗    
      provider = " ",
      hl = { fg = "gray" },
      on_click = {
        callback = function(_, minwid)
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end,
        minwid = function(self)
          return self.bufnr
        end,
        name = "heirline_tabline_close_buffer_callback",
      },
    },
  }

  local TablinePicker = {
    condition = function(self)
      return self._show_picker
    end,
    init = function(self)
      local bufname = vim.api.nvim_buf_get_name(self.bufnr)
      bufname = vim.fn.fnamemodify(bufname, ":t")
      local label = bufname:sub(1, 1)
      local i = 2
      while self._picker_labels[label] do
        label = bufname:sub(i, i)
        if i > #bufname then
          break
        end
        i = i + 1
      end
      self._picker_labels[label] = self.bufnr
      self.label = label
    end,
    provider = function(self)
      return self.label
    end,
    hl = { fg = "red", bold = true },
  }

  local TablineBufferBlock = utils.surround({ "", "" }, function(self)
    return self.is_active and ghl("TabLineSel").bg or ghl("TabLine").bg
  end, { TablinePicker, TablineFileNameBlock, TablineCloseButton })

  local BufferLine = utils.make_buflist(
    TablineBufferBlock,
    { provider = " ", hl = { fg = "gray" } },
    { provider = " ", hl = { fg = "gray" } }
  )

  local TabLineOffset = {
    condition = function(self)
      local win = vim.api.nvim_tabpage_list_wins(0)[1]
      self.winid = win
    end,

    provider = function(self)
      local title = self.title
      local width = vim.api.nvim_win_get_width(self.winid)
      local pad = math.ceil((width - #title) / 2)
      return string.rep(" ", pad) .. title .. string.rep(" ", pad)
    end,

    hl = function(self)
      if vim.api.nvim_get_current_win() == self.winid then
        return "TablineSel"
      else
        return "Tabline"
      end
    end,
  }

  local TabLine = { TabLineOffset, BufferLine }

  vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
  vim.o.showtabline = 2

  ---@diagnostic disable-next-line: redundant-parameter
  require("heirline").setup({
    statusline = StatusLines,
    tabline = TabLine,
  })
end

return M
