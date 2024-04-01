--type conform.options
local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		lua = { "stylua" },

		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },

		sh = { "shfmt" },

		python = { "isort", "black" },

		c = { "clang_format" },
		cpp = { "clang_format" },
		objc = { "clang_format" },
		objcpp = { "clang_format" },
		cuda = { "clang_format" },
		proto = { "clang_format" },
	},

	-- adding same formatter for multiple filetypes can look too much work for some
	-- instead of the above code you could just use a loop! the config is just a table after all!

	format_on_save = function(bufnr)
		-- if vim.bo[bufnr].filetype == "c" then
		-- 	return {}
		-- end

		-- These options will be passed to conform.format()
		return {
			timeout_ms = 500,
			lsp_fallback = true,
		}
	end,
}

require("conform").setup(options)
