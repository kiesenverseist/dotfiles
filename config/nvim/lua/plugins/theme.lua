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
		config = function(_, opts)
			require("flexoki").setup(opts)
			vim.cmd.colorscheme("flexoki")
		end
	},
	{
		"ellisonleao/gruvbox.nvim",
		enabled = true,
		priority = 1000,
		opts = {
			contrast = "hard",
		},
		config = function(_, opts)
			require("gruvbox").setup(opts)
			vim.cmd.colorscheme("gruvbox")
		end
	},
	{
		"dgox16/oldworld.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = {
			variant = "oled",
		},
		config = function(_, opts)
			require("oldworld").setup(opts)
			vim.cmd.colorscheme("oldworld")
		end
	},
}
