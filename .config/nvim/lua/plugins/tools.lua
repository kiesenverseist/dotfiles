return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    cmd = "Oil",
    opts = {
      lsp_file_methods = {
        autosave_changes = true,
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
      },
      columns = {
        "icon",
        -- "size",
        -- "permissions",
        -- "mtime",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "echasnovski/mini.files",
    event = "VeryLazy",
    opts = {
      options = {
        use_as_default_explorer = false,
      },
    },
    version = "*",
  },
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        previewer = true,
        -- Can also set some Telescope picker options
        -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        -- theme_conf = {
        --   border = true,
        --   -- layout_config = {
        --   --   width = 0.8, -- Can set width and height as percent of window
        --   --   height = 0.5,
        --   -- },
        -- },
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
