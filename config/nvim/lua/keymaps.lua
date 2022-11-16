local tb = require("telescope.builtin")
local wk = require("which-key")
local hui = require("harpoon.ui")
local dap = require("dap")
local dui = require("dapui")
local hop = require("hop")
local tint = require("tint")
local lsp_lines = require("lsp_lines")
local spectre = require("spectre")

local utils = require("utils")

vim.g.mapleader = ","

-- ************************************** --
--
--          Visual & Selection
--
-- ************************************** --
wk.register({
  -- Stay in indent mode
  ["<"] = { "<gv", "Indent left" },
  [">"] = { ">gv", "Indent right" },
}, { mode = "v" })

-- ************************************** --
--
--                  Visual
--
-- ************************************** --
wk.register({
  J = { ":move '>+1<CR>gv-gv", "Move line down" },
  K = { ":move '<-2<CR>gv-gv", "Move line up" },
}, { mode = "x" })

-- ************************************** --
--
--                Normal
--
-- ************************************** --
wk.register({
  s = { hop.hint_char1, "Hop char" },
  ["<c-p>"] = { tb.resume, "Resume previous picker" },
  ["<leader>"] = {
    ["/"] = { tb.live_grep, "Live grep" },
    t = {
      name = "+twilight | +telescope | +tint",
      w = { "<cmd>Twilight<cr>", "Toggle twilight" },
      t = { tint.toggle, "Toggle tint" },
    },
    w = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
    g = {
      name = "+git",
      s = {
        name = "+status | +stage",
        {
          t = { tb.git_status, "Git status" },
        },
      },
    },
    b = {
      name = "+buffer",
      f = { tb.buffers, "List of buffers" },
    },
    f = {
      name = "+file | +focus",
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      c = {
        name = "+focus",
        t = { "<cmd>FocusToggle<cr>", "Focus toggle" },
        f = { "<cmd>FocusSplitNicely<cr>", "Focus split nicely" },
      },
    },
    i = {
      name = "+icon",
      c = { "<cmd>IconPickerNormal<cr>", "Pick an icon" },
      y = { "<cmd>IconPickerYank<cr>", "Copy an icon" },
    },
    h = {
      name = "+harpoon",
      a = { require("harpoon.mark").add_file, "Add a file" },
      t = { hui.toggle_quick_menu, "Toggle" },
      n = { hui.goto_next, "Next" },
      p = { hui.goto_previous, "Previous" },
    },
    n = { ":NnnPicker %:p:h<CR>", "Toggle nnn picker" },
    z = { "<Cmd>WindowsMaximize<CR>", "Maximize window" },
    d = {
      name = "+dap/debug",
      o = {
        function()
          dui.open()
          tint.disable()
        end,
        "Open debugger ui",
      },
      c = {
        function()
          dui.close()
          tint.enable()
        end,
        "Close debugger ui",
      },
      t = { dap.terminate, "Terminate debugger" },
      l = { dap.run_last, "Run last" },
      b = { dap.toggle_breakpoint, "Toggle breakpoint" },
    },
    s = {
      name = "+spell | +swap",
      t = { utils.toggle_spell, "Toggle spell check" },
      -- https://github.com/nickjj/dotfiles/blob/master/.vimrc
      p = { "<cmd>normal! mz[s1z=`z<cr>", "Pick first suggestion" },
      w = { "<cmd>ISwap<cr>", "Swap words" },
    },
    l = {
      name = "+lsp",
      t = { lsp_lines.toggle, "Toggle lsp lines" },
    },
    r = {
      -- https://github.com/nickjj/dotfiles/blob/master/.vimrc
      name = "+replace",
      p = { ":%s///g<Left><Left>", "Replace" },
      c = { ":%s///gc<Left><Left>", "Replace with confirmation" },
      s = { spectre.open, "Replace with spectre" },
    },
  },
  ["["] = {
    name = "+goto previous",
    d = { vim.diagnostic.goto_prev, "Diagnostic" },
    e = {
      function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end,
      "Error",
    },
    w = {
      function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
      end,
      "Warning",
    },
    h = {
      function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.HINT })
      end,
      "Hint",
    },
  },
  ["]"] = {
    name = "+goto next",
    d = { vim.diagnostic.goto_next, "Go to next diagnostic" },
    e = {
      function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end,
      "Error",
    },
    w = {
      function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
      end,
      "Warning",
    },
    h = {
      function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.HINT })
      end,
      "Hint",
    },
  },
  ["<F5>"] = { dap.continue, "Continue" },
  ["<F10>"] = { dap.step_over, "Step over" },
  ["<F11>"] = { dap.step_into, "Step into" },
  ["<F12"] = { dap.step_out, "Step out" },
})

-- ********************************************* --
--
--                    Insert
--
-- ********************************************* --
wk.register({
  ["<c-p>"] = { tb.resume, "Resume previous picker" },
  ["<c-o>"] = { "<cmd>IconPickerInsert<cr>", "Pick icon" },
  -- Terminal-like
  ["<c-a>"] = { "<HOME>", "Go to the beginning" },
  ["<c-e>"] = { "<END>", "Go to the end" },
  ["<c-d>"] = { "<DEL>", "Delete next char" },
}, { mode = "i" })
