return {
	'echasnovski/mini.nvim',
	version = '*',
	config = function()
		-- mini icons
		require("mini.icons").setup()
		MiniIcons.mock_nvim_web_devicons()

		-- mini files
		require("mini.files").setup({
			options = { use_as_default_explorer = false, },
			windows = { preview = true, },
		})
		vim.keymap.set("n", "<C-n>", function()
			if not MiniFiles.close() then
				MiniFiles.open()
			end
		end, { desc = "Open file exxporer" })

		-- sessions
		require("mini.sessions").setup({
			verbose = { read = true }
		})
		vim.keymap.set("n", "<leader>sn", function()
			MiniSessions.write(vim.fn.input("Session name: "))
		end, { desc = "[n]ew session" })
		vim.keymap.set("n", "<leader>sw", function()
			MiniSessions.write(MiniSessions.config.file)
		end, { desc = "[w]rite session for cwd" })
		vim.keymap.set("n", "<leader>sd", function()
			MiniSessions.select("delete")
		end, { desc = "[d]elete session" })
		vim.keymap.set("n", "<leader>so", function()
			MiniSessions.select("read")
		end, { desc = "[o]pen session" })

		require("mini.statusline").setup({ use_icons = true })
		require("mini.ai").setup()
		require("mini.surround").setup()
		require("mini.move").setup()
		require("mini.diff").setup()
	end,
}
