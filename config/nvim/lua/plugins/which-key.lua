return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    local utils = require("hnbnh.utils")

    wk.register({
      ["/"] = { "<cmd>Telescope live_grep_args<cr>", "Live grep" },
      q = { "<cmd>q<cr>", "Quit" },
      b = { "<cmd>Neotree buffers<cr>", "List all buffers" },
      f = { "<cmd>Telescope find_files previewer=false<cr>", "Find files" },
      n = { "<cmd>Neotree reveal<cr>", "Open neo-tree" },
      z = { "<cmd>WindowsMaximize<CR>", "Maximize window" },
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
        r = { "<cmd>lua require('ssr').open()<cr>", "Replace with ssr" },
      },
      l = { "<cmd>vsplit<cr>", "vsplit" },
      j = { "<cmd>split<cr>", "split" },
      p = { "<cmd>Telescope pickers<cr>", "Pickers history" },
    }, { mode = "n", prefix = "<leader>" })

    wk.register({
      r = { name = "+refactor", p = { "<cmd>lua require('refactoring').select_refactor()<cr>", "Refactor" } },
    }, { mode = "v", prefix = "<leader>" })

    wk.register({
      s = { ":g//normal @i" .. utils.duplicate("<left>", 10), "Search and apply macro" },
      a = { ":normal @i<cr>", "Apply macro" },
    }, { mode = "x", prefix = "<leader>" })
  end,
}
