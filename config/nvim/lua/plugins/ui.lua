local utils = require("hnbnh.utils")

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

local icons = {
  diagnostics = {
    error = " ",
    warn = " ",
    hint = " ",
    info = " ",
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "auto",
          component_separators = " ",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              function()
                return "󰁨  " .. (vim.g.autoformat_enabled and "" or "")
              end,
              separator = " ",
              padding = { left = 1, right = 1 },
              color = function()
                return vim.g.autoformat_enabled and "lualine_a_terminal" or "@text.danger"
              end,
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.error,
                warn = icons.diagnostics.warn,
                hint = icons.diagnostics.hint,
                info = icons.diagnostics.info,
              },
            },
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1,
                right = 0,
              },
            },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_x = {
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = utils.fg("Debug"),
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "quickfix", "fugitive" },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    config = function()
      require("neo-tree").setup({
        buffers = {
          show_unloaded = true,
          window = {
            mappings = {
              ["d"] = "buffer_delete",
            },
          },
        },
        filesystem = {
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
          },
          window = {
            mappings = {
              ["Y"] = "yank_path",
              ["<space>"] = "none",
              ["s"] = "none",
            },
            fuzzy_finder_mappings = {
              ["<C-j>"] = "move_cursor_down",
              ["<C-k>"] = "move_cursor_up",
            },
          },
          commands = {
            yank_path = function(state)
              vim.fn.setreg("+", state.tree:get_node().path)
              vim.notify("Yanked path to clipboard")
            end,
          },
        },
        window = {
          mappings = {
            ["l"] = "open",
            ["L"] = "focus_preview",
            ["h"] = "close_node",
          },
        },
      })
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    opts = {
      create_event = function()
        local colorful_winsep = require("colorful-winsep")
        local win_n = require("colorful-winsep.utils").calculate_number_windows()
        if win_n == 2 then
          local win_id = vim.fn.win_getid(vim.fn.winnr("h"))
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win_id) })
          if filetype == "neo-tree" then
            colorful_winsep.NvimSeparatorDel()
          end
        end
      end,
    },
    event = { "WinNew" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      whitespace = { highlight = { "Whitespace", "NonText" } },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufRead",
    keys = {
      {
        "n",
        function()
          vim.fn.execute("normal! " .. vim.v.count1 .. "n" .. "zz")
          require("hlslens").start()
        end,
        desc = "Next match",
      },
      {
        "N",
        function()
          vim.fn.execute("normal! " .. vim.v.count1 .. "N" .. "zz")
          require("hlslens").start()
        end,
        desc = "Previous match",
      },
    },
    opts = { calm_down = true, nearest_only = true },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local wk = require("which-key")

        wk.register({
          buffer = bufnr,
          ["<leader>"] = {
            g = {
              name = "+git",
              h = { gs.stage_hunk, "Stage hunk" },
              H = { gs.reset_hunk, "Reset hunk" },
              b = { gs.stage_buffer, "Stage buffer" },
              B = { gs.reset_buffer, "Reset buffer" },
              u = { gs.undo_stage_hunk, "Undo stage" },
              o = { gs.preview_hunk, "Preview hunk" },
            },
          },
          ["]c"] = { next_hunk, "Go to next hunk" },
          ["[c"] = { prev_hunk, "Go to previous hunk" },
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
    },
  },
  {
    "ziontee113/icon-picker.nvim",
    cmd = "IconPickerInsert",
    keys = {
      { "<leader>ic", "<cmd>IconPickerInsert<cr>", { mode = { "i", "n" }, desc = "Pick icon" } },
    },
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true,
      })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    config = function()
      local sep =
        "══════════════════════════════════"
      require("spectre").setup({
        line_sep_start = sep,
        result_padding = "  ",
        line_sep = sep,
      })
    end,
  },
  { "stevearc/dressing.nvim", event = "VeryLazy", config = true },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
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
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
        },
      })
    end,
    opts = {},
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        keymaps = {
          view = {
            { "n", "<leader>ch", actions.conflict_choose("ours"), { desc = "Choose the left window" } },
            { "n", "<leader>cm", actions.conflict_choose("all"), { desc = "Choose the middle window" } },
            { "n", "<leader>cl", actions.conflict_choose("theirs"), { desc = "Choose the right window" } },
            { "n", "<leader>cH", actions.conflict_choose_all("ours"), { desc = "Choose the left window" } },
            { "n", "<leader>cM", actions.conflict_choose_all("all"), { desc = "Choose the middle window" } },
            { "n", "<leader>cL", actions.conflict_choose_all("theirs"), { desc = "Choose the right window" } },
          },
        },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function()
      vim.notify = require("notify")
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    config = true,
    opts = {
      sources = {
        path = {
          relative_to = function()
            return vim.fn.expand("%:p:h")
          end,
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = true,
      },
      messages = {
        enabled = false,
      },
      notify = {
        enabled = false,
      },
      popupmenu = {
        enabled = false,
      },
      smart_move = {
        enabled = false,
      },
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = {
        enabled = false,
      },
      bottom = {
        "Trouble",
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- don't open help files in edgy that we're editing
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
        { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
      },
      left = {
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          pinned = true,
          open = "Neotree",
        },
        { title = "Neotest Summary", ft = "neotest-summary" },
        {
          title = "Neo-Tree Git",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          pinned = true,
          open = "Neotree position=right git_status",
        },
        {
          title = "Neo-Tree Buffers",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "buffers"
          end,
          pinned = true,
          open = "Neotree position=top buffers",
        },
      },
    },
  },
}
