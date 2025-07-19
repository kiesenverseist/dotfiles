return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = { "c",
			"lua", "luadoc",
			"vim", "vimdoc",
			"query",
			"markdown", "markdown_inline",
			"css", "scss", "html", "javascript", "svelte", "tsx",
			"latex", "typst", "norg",
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
}
