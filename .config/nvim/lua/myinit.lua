local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

if vim.g.neovide == true then
  vim.o.guifont = "FiraCode Nerd Font:h16"
  vim.o.winblend = 30
  vim.o.pumblend = 30

  -- vim.g.neovide_transparency = 0.95
  -- vim.g.transparency = 0.95

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0

  vim.g.neovide_remember_window_size = false

  vim.g.neovide_position_animation_length = 0.15
  vim.g.neovide_scroll_animation_length = 0.20
  vim.g.neovide_cursor_animation_length = 0.05

  -- vim.g.neovide_profiler = true
end

local opt = vim.opt
local api = vim.api

-- Indenting
-- opt.expandtab = true
-- opt.shiftwidth = 4
opt.smartindent = false
-- opt.tabstop = 4
-- opt.softtabstop = 4

-- code folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.wo.relativenumber = true
opt.scrolloff = 10

local function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command("augroup " .. group_name)
    api.nvim_command "autocmd!"
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      api.nvim_command(command)
    end
    api.nvim_command "augroup END"
  end
end

local autoCommands = {
  -- other autocommands
  open_folds = {
    { "BufEnter", "*", "normal zR" },
  },
}

nvim_create_augroups(autoCommands)

-- Add directory to zoxide when changed for example with `:cd`
local zoxide_group = vim.api.nvim_create_augroup("zoxide", {})
vim.api.nvim_create_autocmd({ "DirChanged" }, {
  group = zoxide_group,
  callback = function(ev)
    vim.fn.system { "zoxide", "add", ev.file }
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim.api.nvim_create_autocmd("TermLeave", {
--   callback = function(ctx)
--     vim.fn.execute "normal <CR>"
--   end,
--   nested = true,
-- })

-- vimtex config (move to separete file later)
vim.g.vimtex_mappings_prefix = "<S-Space>"
vim.g.vimtex_compiler_method = "tectonic"
vim.g.vimtex_view_method = "zathura"

-- hypr treesitter stuff
vim.filetype.add {
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  extension = { templ = "templ" },
}
