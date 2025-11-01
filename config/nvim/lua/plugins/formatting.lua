return {
	'stevearc/conform.nvim',
	keys = {
		{ mode = { "n", "x" }, "<leader>bf", function() require("conform").format() end, desc = "[f]ormat buffer" },
	},
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			["_"] = { lsp_format = "fallback" },
		},

		default_formatter_opts = {
			lsp_format = "fallback",
		},
	},
}
