-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

if vim.g.neovide == true then
  vim.o.guifont = "FiraCode Nerd Font:h14"

  vim.g.neovide_transparency = 0.95
  vim.g.transparency = 0.95

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end
