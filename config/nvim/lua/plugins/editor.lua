local function toggle_telescope(harpoon_files)
  local conf = require("telescope.config").values
  local file_paths = {}

  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  -- FIXME: Add missing icons
  require("telescope.pickers")
    .new(conf, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = false,
      sorter = conf.generic_sorter({}),
    })
    :find()
end

return {
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "echasnovski/mini.trailspace", event = "BufReadPost", config = true },
  { "tpope/vim-repeat" },
  {
    "nvim-zh/colorful-winsep.nvim",
    cond = not vim.g.vscode,
    event = { "WinLeave" },
    config = true,
    opts = {
      smooth = false,
    },
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
  {
    "mrjones2014/legendary.nvim",
    cond = not vim.g.vscode,
    priority = 10000,
    lazy = false,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      { "<c-p>", "<cmd>Legendary<cr>", mode = { "n", "v" } },
    },
    opts = {
      extensions = {
        lazy_nvim = true,
      },
      commands = {
        {
          ":CopyFileName",
          function()
            vim.cmd("let @+ = expand('%')")
            vim.notify("Copied file name to clipboard")
          end,
          desc = "CopyFileName",
        },
        {
          ":CopyAbsoluteFilePath",
          function()
            vim.cmd("let @+ = expand('%:p')")
            vim.notify("Copied ABSOLUTE file path to clipboard")
          end,
          desc = "CopyAbsoluteFilePath",
        },
        {
          ":CopyRelativePathWithCurrentLine",
          function()
            local path = vim.fn.expand("%:p:.")
            local current_line = vim.fn.line(".")

            vim.fn.setreg("+", path .. ":" .. current_line)
            vim.notify("Copied RELATIVE file path with current LINE to clipboard")
          end,
          desc = "CopyRelativePathWithCurrentLine",
        },
        {
          ":Rspec",
          function()
            local path = vim.fn.expand("%:p:.")
            local current_line = vim.fn.line(".")

            vim.fn.setreg("+", "rspec " .. path .. ":" .. current_line)
            vim.notify("Copied rspec command")
          end,
          desc = "Rspec",
        },
        {
          ":CopyRelativeFilePath",
          function()
            vim.cmd("let @+ = expand('%:p:.')")
            vim.notify("Copied RELATIVE file path to clipboard")
          end,
          desc = "CopyRelativeFilePath",
        },
        {
          ":DisableAutoformat",
          function()
            vim.g.autoformat = false
          end,
          desc = "DisableAutoformat",
        },
        {
          ":EnableAutoformat",
          function()
            vim.g.autoformat = true
          end,
          desc = "EnableAutoformat",
        },
        {
          ":ToggleAutoformat",
          function()
            vim.g.autoformat = not vim.g.autoformat
          end,
          desc = "ToggleAutoformat",
        },
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    keys = {
      -- stylua: ignore
      { "<leader>h", function() toggle_telescope(require("harpoon"):list()) end, desc = "Open harpoon window" },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = { format = { lua = false } },
      lsp = {
        progress = { enabled = false },
        hover = { enabled = false },
        signature = { enabled = false },
      },
      preset = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = false,
      },
      messages = { enabled = false },
      notify = { enabled = false },
      popupmenu = { enabled = false },
      smart_move = { enabled = false },
    },
  },
  {
    "folke/which-key.nvim",
    opts_extend = { "spec" },
    opts = {
      spec = {
        {
          { "<leader>b", group = nil },
        },
      },
    },
  },
}
