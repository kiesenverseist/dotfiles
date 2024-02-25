---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<leader>G"] = {
			function()
				require("nvterm.terminal").send("lazygit", "float")
			end,
			"open lazygit",
		},
	},
}

-- more keybinds!

M.telescope = {
	plugin = true,

	n = {
		["<C-p>"] = { "<cmd> Telescope find_files <CR>", "Find files" },
		["<leader>pp"] = { "<cmd> Telescope project <CR>", "Pick project" },
		["<leader>cd"] = { "<cmd> Telescope zoxide list <CR>", "change dir zoxide" },
		["<leader>u"] = { "<cmd> Telescope undo <CR>", "undo tree" },
	},
}

M.obsidian = {
	plugin = true,

	n = {
		["gf"] = {
			function()
				require("obsidian.mapping").gf_passthrough()
			end,
			"goto file",
		},
	},
}

M.minialign = {
	plugin = true,

	n = {
		["ga"] = { "ga", "which_key_ignore" },
		["gA"] = { "ga", "which_key_ignore" },
	},
}

-- dap
M.dap = {
	plugin = true,

	n = {
		["<leader>db"] = {
			function()
				require("dap").toggle_breakpoint()
			end,
			"toggle breakpoint",
		},
		["<leader>dB"] = {
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			"toggle breakpoint condition",
		},
		["<F5>"] = {
			function()
				require("dap").continue()
			end,
			"continue / start",
		},
		["<F2>"] = {
			function()
				require("dap").step_over()
			end,
			"step over",
		},
		["<F1>"] = {
			function()
				require("dap").step_into()
			end,
			"step into",
		},
		["<F3>"] = {
			function()
				require("dap").step_out()
			end,
			"step into",
		},
		["<leader>do"] = {
			function()
				require("dapui").toggle()
			end,
			"open ui",
		},
		["<leader>dx"] = {
			function()
				require("dap").close()
			end,
			"close debugging",
		},
	},
}

-- neotest
M.neotest = {
	plugin = true,

	n = {
		["<leader>tt"] = {
			function()
				require("neotest").run.run()
			end,
			"Run nearest test",
		},
		["<leader>tf"] = {
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			"Run tests in file",
		},
		["<leader>ts"] = {
			function()
				require("neotest").run.stop()
			end,
			"Stop nearest test",
		},
		["<leader>tS"] = {
			function()
				require("neotest").run.stop(vim.vn.expand("%"))
			end,
			"Stop tests in file",
		},
		["<leader>tp"] = {
			function()
				require("neotest").summary.toggle()
			end,
			"Toggle test summary",
		},
		["<leader>dt"] = {
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			"Debug nearest test",
		},
	},
}

-- trouble
M.trouble = {
	n = {
		["<leader>T"] = {
			function()
				require("trouble").toggle()
			end,
			"Toggle Trouble",
		},
		["]d"] = {
			function()
				require("trouble").next({ skip_groups = true, jump = true })
			end,
			"Trouble next",
		},
		["[d"] = {
			function()
				require("trouble").next({ skip_groups = true, jump = true })
			end,
			"Trouble previous",
		},
	},
}

-- lsp extra binds
M.lspconfig = {
	plugin = true,

	n = {
		["<leader>lD"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			"LSP definition type",
		},
	},
}

-- notify
M.notify = {
	plugin = true,

	n = {
		["<leader>D"] = {
			function()
				require("notify").dismiss()
			end,
			"Dismiss notifications",
		},
	},
}

-- neovide bindings
if vim.g.neovide then
	M.neovide = {
		n = {
			["<C-=>"] = { ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>", "Neovide zoom in" },
			["<C-->"] = { ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>", "Neovide zoom out" },
			["<C-0>"] = { ":lua vim.g.neovide_scale_factor = 1<CR>", "Neovide reset zoom" },
		},
	}
end

return M
