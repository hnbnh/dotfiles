return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    local utils = require("hnbnh.utils")

    wk.register({
      ["/"] = { "<cmd>Telescope live_grep_args<cr>", "Live grep" },
      q = { "<cmd>q<cr>", "Quit" },
      a = { t = { "<cmd>AerialToggle<cr>", "Toggle aerial" } },
      t = { "<cmd>Neotree reveal<cr>", "Open neo-tree" },
      w = { "<cmd>Trouble workspace_diagnostics<cr>", "Toggle Trouble" },
      g = {
        name = "+git",
        d = {
          function()
            local view = require("diffview.lib").get_current_view()
            if view then
              vim.cmd.DiffviewClose()
            else
              vim.cmd.DiffviewOpen()
            end
          end,
          "Diffview",
        },
        p = { "<cmd>Git pull<cr>", "Git pull" },
        P = { "<cmd>Git push<cr>", "Git push" },
        l = { "<cmd>Git blame<cr>", "Git blame" },
        t = { "<cmd>Telescope git_status<cr>", "Git status" },
      },
      b = { "<cmd>Telescope buffers<cr>", "List all buffers" },
      f = { "<cmd>Telescope find_files previewer=false<cr>", "Find files" },
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
        u = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle debugger ui" },
        e = { "<cmd>lua require('dapui').eval()<cr>", "Eval" },
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
      r = {
        -- https://github.com/nickjj/dotfiles/blob/master/.vimrc
        name = "+replace",
        p = { ":%s///g<Left><Left>", "Replace" },
        c = { ":%s///gc<Left><Left>", "Replace with confirmation" },
        s = { "<cmd>lua require('spectre').open()<cr>", "Replace with spectre" },
        r = { "<cmd>lua require('ssr').open()<cr>", "Replace with ssr" },
        f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace with spectre on current file" },
      },
      l = { "<cmd>vsplit<cr>", "vsplit" },
      j = { "<cmd>split<cr>", "split" },
      p = { "<cmd>Telescope pickers<cr>", "Pickers history" },
      P = { "<cmd>lua require('telescope').extensions.yank_history.yank_history({})<cr>", "Paste from Yanky" },
    }, { mode = "n", prefix = "<leader>" })

    wk.register({
      r = { name = "+refactor", p = { "<cmd>lua require('refactoring').select_refactor()<cr>", "Refactor" } },
      g = { name = "+git", b = { ":GBrowse!<cr>", "Git browse" } },
    }, { mode = "v", prefix = "<leader>" })

    wk.register({
      c = {
        name = "ChatGPT",
        c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
        e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
        g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
        t = { "<cmd>ChatGPTRun translate<CR>", "Translate" },
        k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords" },
        d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
        a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
        o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
        s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
        f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
        x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
        r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
        l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },
      },
    }, { mode = { "n", "v" }, prefix = "<leader>" })
  end,
}
