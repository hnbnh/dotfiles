local wk = require("which-key")
local utils = require("hnbnh.utils")

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
  f = {"<cmd>lua require('hop').hint_char2()<cr>", "Hop char" },
  ["<c-p>"] = { "<cmd>Telescope resume<cr>", "Resume previous picker" },
  ["<leader>"] = {
    ["/"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
    t = {
      name = "+twilight | +telescope",
      w = { "<cmd>Twilight<cr>", "Toggle twilight" },
    },
    w = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
    g = {
      name = "+git",
      s = {
        name = "+status | +stage",
        {
          t = { "<cmd>Telescope git_status<cr>", "Git status" },
        },
      },
    },
    b = {
      name = "+buffer",
      f = { "<cmd>Telescope buffers<cr>", "List of buffers" },
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
      a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add a file" },
      t = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle" },
      n = { "<cmd>lua require('harpoon.ui').goto_next()<cr>", "Next" },
      p = { "<cmd>lua require('harpoon.ui').goto_previous()<cr>", "Previous" },
    },
    n = { ":NnnPicker %:p:h<CR>", "Toggle nnn picker" },
    z = { "<cmd>WindowsMaximize<CR>", "Maximize window" },
    d = {
      name = "+dap/debug",
      o = { "<cmd>lua require('dapui').open()<cr>", "Open debugger ui" },
      c = { "<cmd>lua require('dapui').close()<cr>", "Close debugger ui" },
      t = { "<cmd>lua require('dap').terminate()<cr>", "Terminate debugger" },
      l = { "<cmd>lua require('dap').run_last()<cr>", "Run last" },
      b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
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
      t = {
        "<cmd>lua require('lsp_lines').toggle()<CR>",
        "Toggle lsp lines",
      },
    },
    r = {
      -- https://github.com/nickjj/dotfiles/blob/master/.vimrc
      name = "+replace",
      p = { ":%s///g<Left><Left>", "Replace" },
      c = { ":%s///gc<Left><Left>", "Replace with confirmation" },
      s = { "<cmd>lua require('spectre').open()<cr>", "Replace with spectre" },
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
  ["<F5>"] = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
  ["<F10>"] = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
  ["<F11>"] = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
  ["<F12"] = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
})

-- ********************************************* --
--
--                    Insert
--
-- ********************************************* --
wk.register({
  ["<c-p>"] = { "<cmd>Telescope resume<cr>", "Resume previous picker" },
  ["<c-o>"] = { "<cmd>IconPickerInsert<cr>", "Pick icon" },
  -- Terminal-like
  ["<c-a>"] = { "<HOME>", "Go to the beginning" },
  ["<c-e>"] = { "<END>", "Go to the end" },
  ["<c-d>"] = { "<DEL>", "Delete next char" },
}, { mode = "i" })
