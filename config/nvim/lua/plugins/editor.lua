return {
  { "NvChad/nvim-colorizer.lua", cond = not vim.g.vscode, event = "VeryLazy", config = true },
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "echasnovski/mini.trailspace", event = "BufReadPost", config = true },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "nvim-zh/colorful-winsep.nvim",
    cond = not vim.g.vscode,
    event = { "WinLeave" },
    config = true,
  },
  {
    "folke/flash.nvim",
    keys = {
      {
        "s",
        function()
          local Flash = require("flash")

          local function format(opts)
            -- always show first and second label
            return { { opts.match.label1, "FlashMatch" }, { opts.match.label2, "FlashLabel" } }
          end

          Flash.jump({
            search = { mode = "search" },
            label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
            pattern = [[\<]],
            action = function(match, state)
              state:hide()
              Flash.jump({
                search = { max_length = 0 },
                highlight = { matches = false },
                label = { format = format },
                matcher = function(win)
                  -- limit matches to the current label
                  return vim.tbl_filter(function(m)
                    return m.label == match.label and m.win == win
                  end, state.results)
                end,
                labeler = function(matches)
                  for _, m in ipairs(matches) do
                    m.label = m.label2 -- use the second label
                  end
                end,
              })
            end,
            labeler = function(matches, state)
              local labels = state:labels()
              for m, match in ipairs(matches) do
                match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                match.label2 = labels[(m - 1) % #labels + 1]
                match.label = match.label1
              end
            end,
          })
        end,
        { mode = { "n", "x", "o" }, desc = "Flash" },
      },
      {
        "S",
        function()
          require("flash").treesitter({
            label = {
              rainbow = {
                enabled = true,
              },
            },
          })
        end,
        { mode = { "n", "o", "x" }, desc = "Flash treesitter" },
      },
    },
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          jump_labels = true,
        },
      },
    },
  },
}
