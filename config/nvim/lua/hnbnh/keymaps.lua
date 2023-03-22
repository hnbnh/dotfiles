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
  y = { "ygv<esc>", "Yank without moving the cursor to the top" },
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
  f = { "<cmd>lua require('hop').hint_char2()<cr>", "Hop char" },
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
      f = { "<cmd>Telescope buffers<cr>", "List all buffers" },
      p = {
        function()
          local tabline = require("heirline").tabline
          local buflist = tabline._buflist[1]
          buflist._picker_labels = {}
          buflist._show_picker = true
          vim.cmd.redrawtabline()
          local char = vim.fn.getcharstr()
          local bufnr = buflist._picker_labels[char]
          if bufnr then
            vim.api.nvim_win_set_buf(0, bufnr)
          end
          buflist._show_picker = false
          vim.cmd.redrawtabline()
        end,
        "Pick a buffer",
      },
      h = { "<cmd>bprevious<cr>", "Previous buffer" },
      l = { "<cmd>bnext<cr>", "Next buffer" },
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
      T = { "<cmd>lua require('dap').terminate()<cr>", "Terminate debugger" },
      t = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle debugger ui" },
      d = {
        "+languages",
        { r = { "<cmd>RustDebuggables<cr>", "RustDebuggables" } },
      },
      r = { "<cmd>lua require('dap').run_last()<cr>", "Run last" },
      b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
      c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
      h = { "<cmd>lua require('dap').step_back()<cr>", "Step back" },
      l = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
      j = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
      k = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
    },
    s = {
      name = "+spell | +swap | +session",
      t = { utils.toggle_spell, "Toggle spell check" },
      -- https://github.com/nickjj/dotfiles/blob/master/.vimrc
      p = { "<cmd>normal! mz[s1z=`z<cr>", "Pick first suggestion" },
      w = { "<cmd>ISwap<cr>", "Swap words" },
      r = { "<cmd>lua require('persistence').load()<cr>", "Restore session" },
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
      r = { "<cmd>lua require('ssr').open()<cr>", "Replace with ssr" },
      f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace with spectre on current file" },
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
