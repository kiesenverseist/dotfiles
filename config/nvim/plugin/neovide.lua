local o = vim.o
local g = vim.g

-- only run in neovide
if g.neovide ~= true then
	return
end

-- o.guifont = "FiraCode Nerd Font Mono, Symbols Nerd Font"
o.guifont = "Fira Code,Symbols Nerd Font Mono"
o.winblend = 30
o.pumblend = 30

-- g.neovide_transparency = 0.95
-- g.transparency = 0.95

g.neovide_floating_blur_amount_x = 2.0
g.neovide_floating_blur_amount_y = 2.0
g.neovide_remember_window_size = false
g.neovide_position_animation_length = 0.15

-- g.neovide_profiler = true

-- mappings
local map = vim.keymap.set

map("n", "<C-=>", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
end, { desc = "Neovide zoom in" })
map("n", "<C-->", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 0.9
end, { desc = "Neovide zoom out" })
map("n", "<C-0>", function()
	vim.g.neovide_scale_factor = 1
end, { desc = "Neovide reset zoom" })

-- workaround for scroll jumping on buffer change
-- from https://github.com/neovide/neovide/issues/1771
vim.api.nvim_create_autocmd("BufLeave", {
	callback = function()
		vim.g.neovide_scroll_animation_length = 0
		vim.g.neovide_cursor_animation_length = 0
	end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.fn.timer_start(70, function()
			vim.g.neovide_scroll_animation_length = 0.20
			vim.g.neovide_cursor_animation_length = 0.05
		end)
	end,
})

-- get rid of smooth scroll in term
vim.api.nvim_create_autocmd("TermEnter", {
	callback = function()
		vim.g.neovide_scroll_animation_length = 0
		vim.g.neovide_cursor_animation_length = 0
	end,
})
vim.api.nvim_create_autocmd("TermEnter", {
	callback = function()
		vim.g.neovide_scroll_animation_length = 0
		vim.g.neovide_cursor_animation_length = 0
	end,
})
vim.api.nvim_create_autocmd("TermLeave", {
	callback = function()
		vim.fn.timer_start(70, function()
			vim.g.neovide_scroll_animation_length = 0.20
			vim.g.neovide_cursor_animation_length = 0.05
		end)
	end,
})
