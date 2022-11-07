local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer, close and reopen Neovim")
  vim.cmd([[packadd packer.nvim]])
end

local ok, packer = pcall(require, "packer")
if not ok then
  return
end

packer.startup({
  function(use)
    use({ "lewis6991/impatient.nvim", config = [[require("impatient")]] })

    use("wbthomason/packer.nvim")

    -- **** Dependencies **** --
    use("nvim-lua/plenary.nvim")
    use({ "kyazdani42/nvim-web-devicons", event = "VimEnter" })

    -- **** Key binding **** --
    use({ "folke/which-key.nvim", event = "VimEnter", config = [[require("config.which-key")]] })

    -- **** Editing **** --
    use({ "numToStr/Comment.nvim", event = "BufRead", config = [[require("config.comment")]] })
    use({ "lukas-reineke/indent-blankline.nvim", event = "VimEnter", config = [[require("config.indent-blankline")]] })
    use({ "machakann/vim-swap", event = "VimEnter" })
    use({ "kylechui/nvim-surround", event = "VimEnter", config = [[require("config.surround")]] })
    use({ "godlygeek/tabular", cmd = { "Tabularize" } })
    use({ "andymass/vim-matchup", event = "BufReadPost", config = [[require("config.matchup")]] })
    use({
      "zbirenbaum/copilot.lua",
      event = { "InsertEnter" },
      config = function()
        vim.schedule(require("copilot").setup)
      end,
    })
    use({ "jose-elias-alvarez/null-ls.nvim" })
    use({ "tpope/vim-repeat", event = "VimEnter" })
    use({ "norcalli/nvim-colorizer.lua", event = "VimEnter", config = [[require("colorizer").setup()]] })
    use({ "nacro90/numb.nvim", event = "BufEnter", config = [[require("numb").setup()]] })

    -- **** File explorer **** --
    use({ "mcchrish/nnn.vim", config = [[require("config.nnn")]] })
    use({ "ThePrimeagen/harpoon", event = "VimEnter", config = [[require("config.harpoon")]] })

    -- **** Lsp **** --
    use({ "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require("config.lsp")]] })
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("WhoIsSethDaniel/mason-tool-installer.nvim")
    use({ "folke/trouble.nvim", config = [[require("config.trouble")]] })
    use("b0o/schemastore.nvim")
    use({
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = [[require("lsp_lines").setup({ underline = true })]],
    })

    -- **** Status line **** --
    use({ "nvim-lualine/lualine.nvim", event = "VimEnter", config = [[require("config.lualine")]] })

    -- **** Color scheme **** --
    use({ "rebelot/kanagawa.nvim", event = "VimEnter", config = [[require("config.themes")]] })
    use({ "folke/twilight.nvim", event = "BufEnter", config = [[require("config.twilight")]] })
    use({ "levouh/tint.nvim", event = "BufEnter", config = [[require("config.tint")]] })

    -- **** Treesitter **** --
    use({
      "nvim-treesitter/nvim-treesitter",
      event = "BufEnter",
      run = ":TSUpdate",
      config = [[require("config.treesitter")]],
    })
    use({ "nvim-treesitter/nvim-treesitter-context", event = "BufEnter" })
    use({ "nvim-treesitter/nvim-treesitter-textobjects", event = "BufEnter" })
    use({ "JoosepAlviste/nvim-ts-context-commentstring", event = "BufReadPost" })

    -- **** Motion **** --
    use({
      "phaazon/hop.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.hop")
        end, 2000)
      end,
    })

    -- **** Search **** --
    local keys = { { "n", "n" }, { "n", "N" } }
    use({ "kevinhwang91/nvim-hlslens", keys = keys, config = [[require("config.hlslens")]] })

    -- **** Git **** --
    use({ "lewis6991/gitsigns.nvim", event = "BufRead", config = [[require("config.gitsigns")]] })

    -- **** Telescope **** --
    use({ "nvim-telescope/telescope.nvim", config = [[require("config.telescope")]] })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({ "nvim-telescope/telescope-ui-select.nvim" })

    -- **** Snippet **** --
    use({ "rafamadriz/friendly-snippets", event = "VimEnter" })
    use({ "L3MON4D3/LuaSnip", after = "nvim-cmp" })

    -- **** Completion **** --
    use({ "onsails/lspkind-nvim", event = "VimEnter" })
    use({ "hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require("config.nvim-cmp")]] })
    use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" })
    use({ "saadparwaiz1/cmp_luasnip" })
    use({
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua", "nvim-cmp" },
      config = [[require("copilot_cmp").setup()]],
    })

    -- **** Debugger **** --
    use({ "mfussenegger/nvim-dap", event = "VimEnter", config = [[require("config.dap")]] })
    use({ "rcarriga/nvim-dap-ui" })
    use({ "theHamsta/nvim-dap-virtual-text" })
    use({ "mfussenegger/nvim-dap-python" })
    use({ "leoluz/nvim-dap-go" })
    use({ "mxsdev/nvim-dap-vscode-js" })

    -- **** Languages **** --
    use({ "ellisonleao/glow.nvim", branch = "main", cmd = { "Glow" } })
    use("simrat39/rust-tools.nvim")
    use("jose-elias-alvarez/typescript.nvim")

    -- **** Icon **** --
    use({
      "ziontee113/icon-picker.nvim",
      event = "VimEnter",
      config = function()
        require("icon-picker").setup({
          disable_legacy_commands = true,
        })
      end,
    })

    -- **** Layout **** --
    -- use({ "beauwilliams/focus.nvim", config = [[require("config.focus")]] })

    -- **** Browser **** --
    use({
      "glacambre/firenvim",
      run = function()
        vim.fn["firenvim#install"](0)
      end,
    })

    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end,
})
