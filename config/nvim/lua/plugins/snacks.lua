return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@class snacks.Config
	opts = {
		styles = {},
		bigfile = { enabled = true },
		notifier = { enabled = false },
		quickfile = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		lazygit = { configure = true },
		rename = { enabled = true },
	},

	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesActionRename",
			callback = function(event)
				Snacks.rename.on_rename_file(event.data.from, event.data.to)
			end,
		})
	end,
}
