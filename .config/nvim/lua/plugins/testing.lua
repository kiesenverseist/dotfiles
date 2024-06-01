return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    -- adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
  },
  lazy = false,
  -- keys = { ["<leader>t"] = nil },
  -- init = function()
  -- 	require("nvchad.core.utils").load_mappings("neotest")
  -- end,
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-python",
      },
    }
  end,
}
