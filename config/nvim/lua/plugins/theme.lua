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
		enabled = false,
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
	{
		'everviolet/nvim',
		name = 'evergarden',
		enabled = true,
		lazy = false,
		priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
		opts = {
			theme = {
				variant = 'winter', -- 'winter'|'fall'|'spring'|'summer'
				-- accent = 'yellow',
			},
		},
		config = function(_, opts)
			require("evergarden").setup(opts)
			vim.cmd.colorscheme("evergarden")
		end
	},

	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {},
	},
}
