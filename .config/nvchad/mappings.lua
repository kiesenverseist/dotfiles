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

-- neovide bindings
if vim.g.neovide then
  M.neovide = {
    n = {
      ["<C-=>"] = {":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>", "Neovide zoom in"},
      ["<C-->"] = {":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>", "Neovide zoom out"},
      ["<C-0>"] = {":lua vim.g.neovide_scale_factor = 1<CR>", "Neovide reset zoom"},
    },
  }
end

return M
