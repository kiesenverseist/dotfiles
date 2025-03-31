return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	--@type snacks.Config
	opts = {
		styles = {enabled = true},
		bigfile = {enabled = true},
		notifier = {enabled = true},
		quickfile = {enabled = true},
		statuscolumn = {enabled = true},
		rename = {enabled = true},
		picker = {enabled = true},
		indent = {enabled = true},
		image = {enabled = true},
	},
	keys = {
		-- pickers
		{"<C-p>", function() Snacks.picker.smart() end, desc = "Smart find files"},
		{"<leader>fw", function() Snacks.picker.grep() end, desc = "Grep words"},
		{"<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers"},
		{"<leader>fc", function() Snacks.picker.files({cwd=vim.fn.stdpath("config")}) end, desc = "Find nvim config"},
		{"<leader>fh", function() Snacks.picker.help() end, desc = "Find help"},
		{"<leader>fp", function() Snacks.picker.projects(require("configs.projects")) end, desc = "Projects"},
		{"<leader>fz", function() Snacks.picker.zoxide() end, desc = "Find zoxide"},
		{"<leader>fn", function() Snacks.picker.notifications() end, desc = "Find notifications"},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...) Snacks.debug.inspect(...) end
				_G.bt = function() Snacks.debug.backtrace() end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
				Snacks.toggle.diagnostics():map("<leader>td")
				Snacks.toggle.line_number():map("<leader>tl")
				Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>tc")
				Snacks.toggle.treesitter():map("<leader>tT")
				Snacks.toggle.inlay_hints():map("<leader>th")
				Snacks.toggle.indent():map("<leader>tg")
				Snacks.toggle.dim():map("<leader>tD")
			end,
		})
	end,
}
