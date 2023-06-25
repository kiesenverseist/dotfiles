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

-- dap
M.dap = {
  plugin = true,

  n = {
    ["<leader>db"] = { function() require('dap').toggle_breakpoint() end, "toggle breakpoint" },
    ["<leader>dc"] = { function() require('dap').continue() end, "continue / start" },
    ["<leader>do"] = { function() require('dap').step_over() end, "step over" },
    ["<leader>di"] = { function() require('dap').step_into() end, "step into" },
    ["<leader>dr"] = { function() require('dap').repl.open() end, "open repl" },
    ["<leader>dl"] = { function() require('dap').run_last() end, "run last" },
    ["<leader>dx"] = { function() require('dap').close() end, "run last" },
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
