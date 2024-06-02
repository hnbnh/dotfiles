local utils = require("hnbnh.utils")
local constants = require("hnbnh.constants")

local home = vim.fn.expand("$HOME")

local function Terminal(cmd, opts)
  local term_opts = vim.tbl_deep_extend("force", {
    cmd = cmd,
    direction = "float",
    hidden = true,
    on_create = function(term)
      vim.keymap.set("n", "q", function()
        term:close()
      end, { buffer = term.bufnr, silent = true })
    end,
  }, opts or {})

  return utils.Singleton(function()
    return require("toggleterm.terminal").Terminal:new(term_opts)
  end)
end

local Lazygit = Terminal("lazygit", {
  on_close = function()
    require("neo-tree.sources.git_status").refresh()
  end,
})
local Rails_c = Terminal("rails c")
local FloatTerm = Terminal()
local Visidata = Terminal("vd")

return {
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  { "terrastruct/d2-vim", ft = { "d2" } },
  {
    "folke/persistence.nvim",
    cond = not vim.g.vscode,
    event = "BufReadPre",
    module = "persistence",
    config = true,
  },
  {
    "s1n7ax/nvim-window-picker",
    cond = not vim.g.vscode,
    version = "2.*",
    opts = {
      hint = "floating-big-letter",
    },
    config = true,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>cc", "<cmd>ChatGPT<cr>", desc = "ChatGPT", mode = { "n", "v" } },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<cr>", desc = "Edit with instruction", mode = { "n", "v" } },
      { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<cr>", desc = "Grammar Correction", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>ChatGPTRun translate<cr>", desc = "Translate", mode = { "n", "v" } },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<cr>", desc = "Keywords", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<cr>", desc = "Docstring", mode = { "n", "v" } },
      { "<leader>ca", "<cmd>ChatGPTRun add_tests<cr>", desc = "Add Tests", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ChatGPTRun optimize_code<cr>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<cr>", desc = "Summarize", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<cr>", desc = "Fix Bugs", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<cr>", desc = "Roxygen Edit", mode = { "n", "v" } },
      {
        "<leader>cl",
        "<cmd>ChatGPTRun code_readability_analysis<cr>",
        desc = "Code Readability Analysis",
        mode = { "n", "v" },
      },
    },

    opts = {
      api_key_cmd = "gpg --decrypt " .. home .. "/openai_api_key.txt.gpg",
    },
    config = true,
  },
  {
    "kawre/leetcode.nvim",
    lazy = not constants.is_leet,
    opts = {
      lang = "python3",
    },
    config = function(_, opts)
      require("copilot")

      vim.g.autoformat_enabled = false
      vim.cmd("Copilot disable")

      require("leetcode").setup(opts)
    end,
    build = ":TSUpdate html",
  },
  {
    "akinsho/toggleterm.nvim",
    cond = not vim.g.vscode,
    keys = {
      {
        "<c-\\>",
        "<c-\\><c-n>",
        desc = "Close terminal",
        mode = "t",
      },
      {
        "<c-t>t",
        function()
          FloatTerm.new():toggle()
        end,
        desc = "Open floating terminal",
      },
      {
        "<c-g>",
        function()
          Lazygit.new():toggle()
        end,
        desc = "Open lazygit",
      },
      {
        "<c-t>c",
        function()
          Rails_c.new():toggle()
        end,
        desc = "Open rails console",
      },
      {
        "<c-t>v",
        function()
          Visidata.new():toggle()
        end,
        desc = "Open rails console",
      },
    },
  },
  {
    "LunarVim/bigfile.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
  },
}
