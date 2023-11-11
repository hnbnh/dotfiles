local prev_hunk = function()
  local gs = require("gitsigns")

  if vim.wo.diff then
    vim.cmd("norm! [c")
  else
    gs.prev_hunk()
  end
end

local next_hunk = function()
  local gs = require("gitsigns")

  if vim.wo.diff then
    vim.cmd("norm! ]c")
  else
    gs.next_hunk()
  end
end

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    keys = {
      { "<leader>gx", ":GBrowse!<cr>", "Git browse", mode = { "n", "v" } },
      { "<leader>gg", "<cmd>Neotree git_status<cr>", "Neotree git status" },
      { "<leader>gl", "<cmd>Git blame<cr>", "Git blame" },
      {
        "<leader>gd",
        function()
          local view = require("diffview.lib").get_current_view()
          if view then
            vim.g.autoformat_enabled = true
            vim.cmd.DiffviewClose()
          else
            vim.g.autoformat_enabled = false
            vim.cmd.DiffviewOpen()
          end
        end,
        "Diffview",
      },
    },
    dependencies = {
      { "tpope/vim-fugitive", event = "VeryLazy" },
      { "tpope/vim-rhubarb", event = "VeryLazy" },
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]c", next_hunk, "Next Hunk")
        map("n", "[c", prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>gh", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>gH", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>gb", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>gB", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>go", gs.preview_hunk, "Preview Hunk")
        map({ "o", "x" }, "ih", gs.select_hunk, "GitSigns Select Hunk")
      end,
    },
  },
}
