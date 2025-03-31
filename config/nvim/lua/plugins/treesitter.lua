return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = { "c", "lua", "luadoc", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
}
