return {
  -- obsidian
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre "
        .. vim.fn.expand "~"
        .. "/knowledge/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/knowledge/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      dir = "~/knowledge", -- no need to call 'vim.fn.expand' here
      -- Optional, key mappings.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        -- ["gf"] = require("obsidian.mapping").gf_passthrough(),
      },
      -- see below for full list of options 👇
    },
    -- config = function()
    --   require("obsidian").setup()
    -- end
    -- init = function()
    -- 	require("core.utils").load_mappings("obsidian")
    -- end,
  },
  -- {
  --   "oflisback/obsidian-sync.nvim",
  --   config = function() require("obsidian-sync").setup() end,
  --   lazy = false,
  -- },
}
