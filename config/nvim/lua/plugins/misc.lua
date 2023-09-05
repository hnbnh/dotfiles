local home = vim.fn.expand("$HOME")

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
}
