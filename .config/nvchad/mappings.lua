---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

-- more keybinds!

M.telescope = {
  plugin = true,

  n = {
    ["<leader>pp"] = { "<cmd> Telescope project <CR>", "Pick project" },
  },
}

M.minialign = {
  plugin = true,

  n = {
    ["ga"] = { "ga", "which_key_ignore" },
    ["gA"] = { "ga", "which_key_ignore" },
  },
}

return M
