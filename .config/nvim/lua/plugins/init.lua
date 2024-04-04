local overrides = require "configs.overrides"

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/neodev.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- { "folke/neodev.nvim", opts = { lspconfig = false } },

  {
    "williamboman/mason.nvim",
    -- opts = {
    --   ensure_installed = {
    --     "lua-language-server", "stylua",
    --     "html-lsp", "css-lsp", "prettier"
    --   },
    -- },
    opts = overrides.mason,
  },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
