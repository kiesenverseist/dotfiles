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
				default = {
					"avante", -- ai
					"lazydev", -- neovim dev
					"lsp", "path", "snippets", "buffer",
				},
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

	{ "neovim/nvim-lspconfig" },

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"actionshrimp/direnv.nvim",
		opts = {
			async = true,
			type = "dir",
			on_direnv_finished = function() vim.cmd("LspStart") end,
		},
	},

	{
		"j-hui/fidget.nvim",
		lazy = false,
		opts = {
			notification = { override_vim_notify = true, },
		},
		keys = {
			{ "<leader>fn", function() Snacks.picker(require("configs.notifications")) end, desc = "Find [n]otifications" },
			{ "<leader>d",  function() require("fidget").notification.clear() end,          desc = "[d]ismiss notifications" },
		},
	}
}
