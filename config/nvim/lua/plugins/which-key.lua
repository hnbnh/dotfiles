return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    local utils = require("hnbnh.utils")

    wk.register({
      ["<leader>"] = {
        ["/"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
        t = { "<cmd>Neotree<cr>", "Open neo-tree" },
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
        b = { "<cmd>Telescope buffers<cr>", "List all buffers" },
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
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
      },
    })

  end,
}