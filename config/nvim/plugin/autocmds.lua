-- Add directory to zoxide when changed for example with `:cd`
local zoxide_group = vim.api.nvim_create_augroup("zoxide", {})
vim.api.nvim_create_autocmd({ "DirChanged" }, {
	group = zoxide_group,
	callback = function(ev)
		vim.fn.system({ "zoxide", "add", ev.file })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Load theme on terminal open",
	group = vim.api.nvim_create_augroup("term-theme", { clear = true }),
	callback = function()
		vim.cmd("startinsert")
		vim.opt_local.spell = false
	end,
})
