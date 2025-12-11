local o = vim.o

o.mouse = "a"

-- display
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.scrolloff = 8
o.title = true
o.shell = "fish"
o.confirm = true
o.inccommand = 'split'
o.showmode = false

-- indent
o.smartindent = false
o.tabstop = 4
o.shiftwidth = 4
o.breakindent = true

-- code folding
o.foldtext = ""
o.foldenable = false
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"

-- spelling
o.spell = true
o.spelllang = "en_au,en_gb"

-- search
o.ignorecase = true
o.smartcase = true

-- session management
-- o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
o.sessionoptions = "curdir,tabpages,terminal"

-- custom filetypes
vim.filetype.add({
	pattern = {
		[".*/hypr/.*%.conf"] = "hyprlang",
	}, -- hypr treesitter stuff
	extension = {
		templ = "templ",
	},
})

-- diagnostic config
vim.diagnostic.config({ virtual_lines = true })

-- set colour scheme
-- vim.cmd("colorscheme retrobox")
