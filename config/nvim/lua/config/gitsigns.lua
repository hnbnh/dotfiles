local wk = require("which-key")
local gs = require("gitsigns")

local prev_or_next = function(key, action)
  return function()
    if vim.wo.diff then
      return key
    end
    vim.schedule(action)

    return "<Ignore>"
  end
end

gs.setup({
  on_attach = function(bufnr)
    wk.register({
      buffer = bufnr,
      ["<leader>"] = {
        g = {
          name = "+git",
          s = {
            name = "+status | +stage",
            {
              h = { gs.stage_hunk, "Stage hunk" },
              b = { gs.stage_buffer, "Stage buffer" },
            },
          },
          b = { gs.toggle_current_line_blame, "Blame" },
          u = { gs.undo_stage_hunk, "Undo stage" },
          r = {
            name = "+reset",
            H = { gs.reset_hunk, "Reset hunk" },
            B = { gs.reset_buffer, "Reset buffer" },
          },
          p = { gs.preview_hunk, "Preview hunk" },
          -- TODO: Close the left window to quit
          d = { gs.diffthis, "Diff this" },
        },
      },
      ["]c"] = { prev_or_next("]c", gs.next_hunk), "Go to next hunk" },
      ["[c"] = { prev_or_next("[c", gs.prev_hunk), "Go to previous hunk" },
    })

    wk.register({
      ["<leader>"] = {
        g = {
          name = "+git",
          s = { name = "+stage", { h = { gs.stage_hunk, "Stage hunk" } } },
          r = { name = "+reset", H = { gs.reset_hunk, "Reset hunk" } },
        },
      },
    }, { mode = "v" })

    wk.register({
      i = {
        name = "+gitsigns",
        h = { gs.select_hunk, "Select hunk" },
      },
    }, { mode = { "o", "x" } })
  end,
})
