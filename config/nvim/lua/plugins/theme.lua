return {
	{
		"nuvic/flexoki-nvim",
		enabled = false,
		priority = 1000,
		name = "flexoki",
		opts = {
			variant = "moon",
			styles = { bold = true, italic = true },
		},
		config = function(opts)
			require("flexoki").setup(opts)
			vim.cmd.colorscheme("flexoki")
		end
	},
	{
		"ellisonleao/gruvbox.nvim",
		enabled = false,
		priority = 1000,
		opts = {
			contrast = "hard",
		},
		config = function(opts)
			require("gruvbox").setup(opts)
			vim.cmd.colorscheme("gruvbox")
		end
	}
}
