local keys = { { "n", "n" }, { "n", "N" } }

return {
  { "folke/which-key.nvim" },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = { char = "│", show_current_context = true },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "BufReadPost",
    config = function()
      require("lualine").setup()
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufRead",
    keys = keys,
    config = function()
      local wk = require("which-key")
      require("hlslens").setup({ calm_down = true, nearest_only = true })

      wk.register({
        n = {
          [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
          "Next match",
        },
        N = {
          [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
          "Previous match",
        },
      })
    end,
  },
  {
    "phaazon/hop.nvim",
    config = function()
      vim.defer_fn(function()
        require("hop").setup()
      end, 2000)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
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
    end,
  },
  {
    "ziontee113/icon-picker.nvim",
    cmd = "IconPickerInsert",
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true,
      })
    end,
  },
  {
    "windwp/nvim-spectre",
    config = function()
      local sep =
        "══════════════════════════════════"
      require("spectre").setup({
        line_sep_start = sep,
        result_padding = "  👉 ",
        line_sep = sep,
      })
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    event = "BufReadPre",
    config = function()
      local c = require("kanagawa.colors").setup()

      require("colorful-winsep").setup({
        highlight = { bg = c.sumiInk1, fg = c.roninYellow },
      })
    end,
  },
}
