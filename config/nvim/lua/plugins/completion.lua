return {
	{
		'saghen/blink.cmp',
		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				ghost_text = { enabled = true },
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			signature = { enabled = true },
		},

		opts_extend = { "sources.default" },
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},

	{
		"actionshrimp/direnv.nvim",
		opts = {
			async = true,
			type = "dir",
			on_direnv_finished = function () vim.cmd("LspEnable") end,
		},
	},
}
