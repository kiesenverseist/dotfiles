require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del

-- disable some of nvchad's mappings
nomap("n", "<C-c>")
nomap("n", "<C-s>")

--
-- M.general = {
-- 	n = {
-- 		[";"] = { ":", "enter command mode", opts = { nowait = true } },
-- 		["<leader>G"] = {
-- 			function()
-- 				require("nvterm.terminal").send("lazygit", "float")
-- 			end,
-- 			"open lazygit",
-- 		},
-- 	},
-- }
--

-- more telescope stuff
map("n", "<C-p>", "<cmd> Telescope find_files <CR>", { desc = "Telescope Find files" })
map("n", "<leader>pp", "<cmd> Telescope project <CR>", { desc = "Telescope Pick project" })
map("n", "<leader>cd", "<cmd> Telescope zoxide list <CR>", { desc = "Telescope Change dir" })
map("n", "<leader>u", "<cmd> Telescope undo <CR>", { desc = "Telescope Undo tree" })

--
-- M.obsidian = {
-- 	plugin = true,
--
-- 	n = {
-- 		["gf"] = {
-- 			function()
-- 				require("obsidian.mapping").gf_passthrough()
-- 			end,
-- 			"goto file",
-- 		},
-- 	},
-- }

-- M.minialign = {
-- 	plugin = true,
--
-- 	n = {
-- 		["ga"] = { "ga", "which_key_ignore" },
-- 		["gA"] = { "ga", "which_key_ignore" },
-- 	},
-- }
--

-- dap and dapui
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug toggle breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Debug toggle breakpoint condition" })
map("n", "<F5>", function()
  require("dap").continue()
end, { desc = "Debug continue / start" })
map("n", "<F1>", function()
  require("dap").step_into()
end, { desc = "Debug step into" })
map("n", "<F2>", function()
  require("dap").step_over()
end, { desc = "Debug step over" })
map("n", "<F3>", function()
  require("dap").step_out()
end, { desc = "Debug step out" })
map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "Debug open repl" })
map("n", "<leader>dl", function()
  require("dap").run_last()
end, { desc = "Debug run last" })
map("n", "<leader>do", function()
  require("dapui").toggle()
end, { desc = "Debug open ui" })
map("n", "<leader>dx", function()
  require("dap").close()
end, { desc = "Debug close debugging" })

-- neotest
map("n", "<leader>tt", function()
  require("neotest").run.run()
end, { desc = "Test Run nearest" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Test Run in file" })
map("n", "<leader>ts", function()
  require("neotest").run.stop()
end, { desc = "Test Stop nearest" })
map("n", "<leader>tS", function()
  require("neotest").run.stop(vim.vn.expand "%")
end, { desc = "Test Stop in file" })
map("n", "<leader>tp", function()
  require("neotest").summary.toggle()
end, { desc = "Test Toggle summary" })
map("n", "<leader>dt", function()
  require("neotest").run.run { strategy = "dap" }
end, { desc = "Test Debug nearest" })

-- -- trouble
-- M.trouble = {
-- 	n = {
-- 		["<leader>T"] = {
-- 			function()
-- 				require("trouble").toggle()
-- 			end,
-- 			"Toggle Trouble",
-- 		},
-- 		["]d"] = {
-- 			function()
-- 				require("trouble").next({ skip_groups = true, jump = true })
-- 			end,
-- 			"Trouble next",
-- 		},
-- 		["[d"] = {
-- 			function()
-- 				require("trouble").previous({ skip_groups = true, jump = true })
-- 			end,
-- 			"Trouble previous",
-- 		},
-- 	},
-- }

-- -- lsp extra binds
-- M.lspconfig = {
-- 	plugin = true,
--
-- 	n = {
-- 		["<leader>lD"] = {
-- 			function()
-- 				vim.lsp.buf.type_definition()
-- 			end,
-- 			"LSP definition type",
-- 		},
-- 	},
-- }

-- notify
map("n", "<leader>D", function()
  require("notify").dismiss { pending = false, silent = false }
end, { desc = "Dismiss notifications" })

-- compile mode
map("n", "<leader>cc", "<CMD>Compile<CR>", { desc = "Compile in compile mode" })
map("n", "<leader>cr", "<CMD>Recompile<CR>", { desc = "Recompile with last command" })
map("n", "<leader>cn", "<CMD>NextError<CR>")
map("n", "<leader>cp", "<CMD>PrevError<CR>")

-- overwrite default mapping for go to context
map("n", "<leader>gc", function()
  local ok, start = require("indent_blankline.utils").get_current_context(
    vim.g.indent_blankline_context_patterns,
    vim.g.indent_blankline_use_treesitter_scope
  )

  if ok then
    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
    vim.cmd [[normal! _]]
  end
end, { desc = "Jump to current context" })

-- neovide
if vim.g.neovide then
  map("n", "<C-=>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
  end, { desc = "Neovide zoom in" })
  map("n", "<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
  end, { desc = "Neovide zoom out" })
  map("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 1
  end, { desc = "Neovide reset zoom" })
end

-- return M
