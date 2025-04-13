return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	--@type snacks.Config
	opts = {
		styles = {},
		bigfile = {},
		-- notifier = {},
		quickfile = {},
		statuscolumn = {},
		picker = {},
		indent = {},
		image = {},
		input = {},
	},
	keys = {
		-- pickers
		{"<C-p>", function() Snacks.picker.smart() end, desc = "Smart find files"},
		{"<leader>fw", function() Snacks.picker.grep() end, desc = "Grep [w]ords"},
		{"<leader>fb", function() Snacks.picker.buffers() end, desc = "Find [b]uffers"},
		{"<leader>fc", function() Snacks.picker.files({cwd=vim.fn.stdpath("config")}) end, desc = "Find in nvim [c]onfig"},
		{"<leader>fh", function() Snacks.picker.help() end, desc = "Find [h]elp"},
		{"<leader>fp", function() Snacks.picker.projects(require("configs.projects")) end, desc = "Open [p]roject"},
		{"<leader>fz", function() Snacks.picker.zoxide() end, desc = "Open [z]oxide project"},
		-- {"<leader>fn", function() Snacks.picker.notifications() end, desc = "Find [n]otifications"},

		-- misc
		{"gX", function() Snacks.gitbrowse.open() end, desc = "Open git in browser"},
		{"<leader>d", function() Snacks.notifier.hide() end, desc = "[d]ismiss notifications"},
		{"<leader>x", function() Snacks.bufdelete.delete() end, desc = "Close buffer"},

		-- command toggle
		{"<leader>j", function() Snacks.terminal.toggle({"jjui"}) end, desc = "Toggle [j]jui"},
		{"<leader>g", function() Snacks.lazygit.open() end, desc = "Toggle lazy[g]it"},
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
				Snacks.toggle.inlay_hints():map("<leader>ti")
				Snacks.toggle.indent():map("<leader>tg")
				Snacks.toggle.dim():map("<leader>tD")

				vim.api.nvim_create_autocmd("User", {
				  pattern = "MiniFilesActionRename",
				  callback = function(event)
					Snacks.rename.on_rename_file(event.data.from, event.data.to)
				  end,
				})


			end,
		})
	end,
}
