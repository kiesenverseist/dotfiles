vim.opt_local.commentstring = "// %s"
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt.errorformat = {
	"%Wwarning: %m", -- start-of-warning
	"%Eerror: %m", -- start-of-error
	"%C%*[^┌]┌─ %f:%l:%c", -- continuation: boxed, pipe-separated
	"%C%*[^┌]│", -- ignore the vertical bar-only line
	"%-G%.%#", -- ignore the rest
}
vim.opt.makeprg = "cd %:h && gleam build"
