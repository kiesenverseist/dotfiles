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

return M
