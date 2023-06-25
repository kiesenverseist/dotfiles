local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        -- cmd = {"TSBufEnable",},
        config = function()
          require('treesitter-context').setup()
        end,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      {
        "nvim-telescope/telescope-project.nvim",
      },
      {
        "nvim-telescope/telescope-bibtex.nvim",
      },
    }
  },

  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = {
      {
        "neovim/nvim-lspconfig"
      },
      {
        "nvim-treesitter/nvim-treesitter",
      },
    }
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },


  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`", "c", "v", "g", "y", "z" },
  },

  {
    "echasnovski/mini.align",
    keys = {"ga", "gA"},
    init = function()
      require("core.utils").load_mappings "minialign"
    end,
    config = function()
      require("mini.align").setup()
    end
  },

  {
    "windwp/nvim-projectconfig",
    lazy = false,
    config = function()
      require("nvim-projectconfig").setup({autocmd = true})
    end
  },

  {
    "direnv/direnv.vim",
    lazy = false,
  },

  -- debugging support
  {
    "mfussenegger/nvim-dap",
    lazy=false,
    init = function()
      require("core.utils").load_mappings "dap"
    end,
    config = function()
      require "custom.configs.dapconfig"
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy=false,
    dependencies = {
      {
        "mfussenegger/nvim-dap",
      },
    },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
