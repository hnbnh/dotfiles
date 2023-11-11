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
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = true },
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "ThePrimeagen/refactoring.nvim", config = true },
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    keys = {
      { "[y", "<Plug>(YankyCycleBackward)", { mode = { "n" }, desc = "Yanky cycle backward" } },
      { "]y", "<Plug>(YankyCycleForward)", { mode = { "n" }, desc = "Yaunky cycle forward" } },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { mode = { "n" }, desc = "Yanky put indent before linewise" } },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", { mode = { "n" }, desc = "Yanky put indent after linewise" } },
      {
        ">p",
        "<Plug>(YankyPutIndentAfterShiftRight)",
        { mode = { "n" }, desc = "Yanky put indent after shift right" },
      },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { mode = { "n" }, desc = "Yanky put indent after shift left" } },
      {
        ">P",
        "<Plug>(YankyPutIndentBeforeShiftRight)",
        { mode = { "n" }, desc = "Yanky put indent before shift right" },
      },
      {
        "<P",
        "<Plug>(YankyPutIndentBeforeShiftLeft)",
        { mode = { "n" }, desc = "Yanky put indent before shift left" },
      },
      { "=p", "<Plug>(YankyPutAfterFilter)", { mode = { "n" }, desc = "Yanky put after filter" } },
      { "=P", "<Plug>(YankyPutBeforeFilter)", { mode = { "n" }, desc = "Yanky put before filter" } },
      { "y", "<Plug>(YankyYank)", { mode = { "n", "x" }, desc = "Yank" } },
      { "p", "<Plug>(YankyPutAfter)", { mode = { "n", "x" }, desc = "Put after" } },
      { "P", "<Plug>(YankyPutBefore)", { mode = { "n", "x" }, desc = "Put before" } },
      { "gp", "<Plug>(YankyGPutAfter)", { mode = { "n", "x" }, desc = "GPut after" } },
      { "gP", "<Plug>(YankyGPutBefore)", { mode = { "n", "x" }, desc = "GPut before" } },
      { "<leader>P", "<cmd>lua require('telescope').extensions.yank_history.yank_history({})<cr>", "Paste from Yanky" },
    },
    opts = {
      highlight = { timer = 300 },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    init = function()
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
      vim.o.foldlevel = 99
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1"
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      open_fold_hl_timeout = 400,
      close_fold_kinds = { "imports", "comment" },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}

        local suffix = (" ↙ %d"):format(endLnum - lnum)
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
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        mode = { "n" },
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        mode = { "n" },
        desc = "Close all folds",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        mode = { "n" },
        desc = "Open folds except kinds",
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  { "echasnovski/mini.trailspace", event = "BufReadPost", config = true },
  {
    "johmsalas/text-case.nvim",
    config = true,
    event = "VeryLazy",
    keys = {
      {
        "gwc",
        "<cmd>lua require('textcase').current_word('to_camel_case')<CR>",
        mode = { "n", "x" },
        desc = "camelCase",
      },
      {
        "gwC",
        "<cmd>lua require('textcase').current_word('to_constant_case')<CR>",
        mode = { "n", "x" },
        desc = "CONSTANT_CASE",
      },
      {
        "gwd",
        "<cmd>lua require('textcase').current_word('to_dash_case')<CR>",
        mode = { "n", "x" },
        desc = "dash-case",
      },
      {
        "gwD",
        "<cmd>lua require('textcase').current_word('to_dot_case')<CR>",
        mode = { "n", "x" },
        desc = "dot.case",
      },
      {
        "gwp",
        "<cmd>lua require('textcase').current_word('to_pascal_case')<CR>",
        mode = { "n", "x" },
        desc = "PascalCase",
      },
      {
        "gwP",
        "<cmd>lua require('textcase').current_word('to_phrase_case')<CR>",
        mode = { "n", "x" },
        desc = "Phrase Case",
      },
      {
        "gws",
        "<cmd>lua require('textcase').current_word('to_snake_case')<CR>",
        mode = { "n", "x" },
        desc = "snake_case",
      },
      {
        "gwt",
        "<cmd>lua require('textcase').current_word('to_title_case')<CR>",
        mode = { "n", "x" },
        desc = "Title Case",
      },
      {
        "gwx",
        "<cmd>lua require('textcase').current_word('to_path_case')<CR>",
        mode = { "n", "x" },
        desc = "path/case",
      },
    },
  },
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
    config = true,
  },
}
