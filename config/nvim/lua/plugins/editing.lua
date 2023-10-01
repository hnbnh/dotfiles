return {
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  { "mizlan/iswap.nvim", cmd = "ISwap" },
  { "godlygeek/tabular", cmd = "Tabularize" },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = true },
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "tpope/vim-rhubarb", event = "VeryLazy" },
  { "ThePrimeagen/refactoring.nvim", config = true },
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    opts = {
      highlight = { timer = 300 },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    init = function()
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  { "echasnovski/mini.trailspace", event = "BufReadPost", config = true },
}
