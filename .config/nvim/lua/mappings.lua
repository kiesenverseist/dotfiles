local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", "<C-i>", "<C-I>")

require "nvchad.mappings"

-- disable some of nvchad's mappings
nomap("n", "<C-c>") -- copy file
nomap("n", "<C-s>") -- save
nomap("t", "<C-x>") -- exit term
nomap("n", "<leader>n") -- line num
nomap("n", "<leader>rn") -- rel line num
nomap("n", "<leader>fm") -- fmt
nomap("n", "<leader>e") -- nvim tree

-- quickfix list nav
map("n", "<M-j>", "<cmd> cnext <CR>", { desc = "Next quickfix" })
map("n", "<M-k>", "<cmd> cprev <CR>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd> cnext <CR>", { desc = "Next quickfix" })
map("n", "[q", "<cmd> cprev <CR>", { desc = "Previous quickfix" })
map("n", "]Q", "<cmd> cfirst <CR>", { desc = "First quickfix" })
map("n", "[Q", "<cmd> clast <CR>", { desc = "Last quickfix" })

map("n", "]l", "<cmd> lnext <CR>", { desc = "Next locationlist" })
map("n", "[l", "<cmd> lprev <CR>", { desc = "Previous locationlist" })
map("n", "]L", "<cmd> lfirst <CR>", { desc = "First locationlist" })
map("n", "[L", "<cmd> llast <CR>", { desc = "Last locationlist" })

-- toggles
map("n", "<leader>Tn", "<cmd>set nu!<CR>", { desc = "Toggle line number" })
map("n", "<leader>Tr", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" }) --

-- resize
map("n", "<C-.>", "<C-w>10>")
map("n", "<C-,>", "<C-w>10<")
-- map("n", "<C-t>", "<C-w>+")
-- map("n", "<C-s>", "<C-w>-")

-- more telescope stuff
map("n", "<C-p>", "<cmd> Telescope find_files <CR>", { desc = "Telescope Find files" })
map("n", "<leader>cd", "<cmd> Telescope zoxide list <CR>", { desc = "Telescope Change dir" })
map("n", "<leader>u", "<cmd> Telescope undo <CR>", { desc = "Telescope Undo tree" })

-- mini.files
map("n", "<C-n>", function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end, { desc = "MiniFiles toggle" })

map("n", "<leader>o", require("oil").toggle_float, { desc = "Oil" })
map("n", "<M-->", "<cmd> Oil <CR>", { desc = "Oil" })

local files_set_cwd = function(path)
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = MiniFiles.get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    map("n", "g~", files_set_cwd, { buffer = args.data.buf_id })
  end,
})

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
map("n", "<F1>", require("dap").continue, { desc = "Debug continue / start" })
map("n", "<F2>", require("dap").step_into, { desc = "Debug step into" })
map("n", "<F3>", require("dap").step_over, { desc = "Debug step over" })
map("n", "<F4>", require("dap").step_out, { desc = "Debug step out" })
map("n", "<F5>", require("dap").step_out, { desc = "Debug step out" })
map("n", "<F12>", require("dap").step_out, { desc = "Debug step out" })
map("n", "<leader>dr", require("dap").repl.open, { desc = "Debug open repl" })
map("n", "<leader>dl", require("dap").run_last, { desc = "Debug run last" })
map("n", "<leader>do", require("dapui").toggle, { desc = "Debug open ui" })
map("n", "<leader>dx", require("dap").close, { desc = "Debug close debugging" })

-- neotest
map("n", "<leader>tt", require("neotest").run.run, { desc = "Test Run nearest" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Test Run in file" })
map("n", "<leader>ts", require("neotest").run.stop, { desc = "Test Stop nearest" })
map("n", "<leader>tS", function()
  require("neotest").run.stop(vim.vn.expand "%")
end, { desc = "Test Stop in file" })
map("n", "<leader>tp", require("neotest").summary.toggle, { desc = "Test Toggle summary" })
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

-- lsp extra binds
map("n", "<leader>Ti", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- format
map("n", "<leader>cf", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "General Format file" })

-- notify
map("n", "<leader>X", function()
  require("notify").dismiss { pending = false, silent = false }
end, { desc = "Dismiss notifications" })

-- compile mode
map("n", "<leader>Cc", "<CMD>Compile<CR>", { desc = "Compile in compile mode" })
map("n", "<leader>Cr", "<CMD>Recompile<CR>", { desc = "Recompile with last command" })
map("n", "<leader>Cn", "<CMD>NextError<CR>", { desc = "Next compile error" })
map("n", "<leader>Cp", "<CMD>PrevError<CR>", { desc = "Previous compile error" })

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

-- treesitter context
map("n", "<leader>Tc", "<CMD>TSContextToggle<CR>", { desc = "Toggle Treesitter context" })

-- auto session
map("n", "<leader>sf", "<cmd>SessionSearch<CR>", { desc = "Session search" })
map("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session" })
map("n", "<leader>sa", "<cmd>SessionToggleAutoSave<CR>", { desc = "Toggle autosave" })

-- lazygit
map("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

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

map({ "n", "t" }, "<M-g>", function()
  require("nvchad.term").toggle { pos = "float", id = "lazyTerm", cmd = "lazygit", clear_cmd = false }
end, { desc = "toggle lazygit term" })

-- terminal bindings
map({ "t" }, "<M-ESC>", function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(win, true)
end, { desc = "Terminal Close term in terminal mode" })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Terminal escape mode" })
map("t", "<ESC>", "<ESC>", { desc = "Terminal send escape" })
map("t", "<C-[><C-[>", "<C-\\><C-n>", { desc = "Terminal escape mode" })
map("t", "<C-[>", "<ESC>", { desc = "Terminal send escape" })

map("t", "<C-w>h", "<C-\\><C-n><C-w>h")
map("t", "<C-w>j", "<C-\\><C-n><C-w>j")
map("t", "<C-w>k", "<C-\\><C-n><C-w>k")
map("t", "<C-w>l", "<C-\\><C-n><C-w>l")

map("n", "<M-t>", function()
  vim.fn.termopen(vim.o.shell)
end, { desc = "Terminal open normal" })
-- map("n", "<M-t>", "<CMD> term <CR>", { desc = "Terminal open normal" })

-- kubectl
map("n", "<leader>K", function()
  require("kubectl").toggle()
end, { desc = "Kubectl", noremap = true, silent = true })

-- neovide
if vim.g.neovide then
  map("n", "<C-=>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end, { desc = "Neovide zoom in" })
  map("n", "<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 0.9
  end, { desc = "Neovide zoom out" })
  map("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 1
  end, { desc = "Neovide reset zoom" })
end
