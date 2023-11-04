local utils = require("hnbnh.utils")

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

return {
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  { "terrastruct/d2-vim", ft = { "d2" } },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = true,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    opts = {
      hint = "floating-big-letter",
    },
    config = true,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    opts = {
      api_key_cmd = "gpg --decrypt " .. home .. "/openai_api_key.txt.gpg",
    },
    config = true,
  },
  {
    "Dhanus3133/LeetBuddy.nvim",
    cmd = { "LBQuestions", "LBQuestion", "LBReset", "LBTest", "LBSubmit" },
    config = true,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<esc>",
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
    },
  },
}
