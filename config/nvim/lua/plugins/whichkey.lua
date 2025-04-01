return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		delay = 300,
		icons = { mappings = true,},
		spec = {
			{ '<leader>f', group = '[f]ind' },
			{ '<leader>t', group = '[t]oggle' },
			{ '<leader>b', group = '[b]uffer' },
			{ '<leader>s', group = '[s]ession' },
			{ '<leader>l', group = '[l]sp' },
			{ '<leader>lw', group = '[w]orkspace' },
		},
	},
}
