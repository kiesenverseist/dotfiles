local map = vim.keymap.set

map("n", "<esc>", "<cmd>nohlsearch<CR>")

map("t", "<esc><esc>", "<C-\\><C-n>", { desc = 'Exit terminal mode' })
map("t", "<C-[><C-[>", "<C-\\><C-n>", { desc = 'Exit terminal mode' })

-- go to tab
map("n", "<M-1>", "1gt")
map("n", "<M-2>", "2gt")
map("n", "<M-3>", "3gt")

-- formatting
map("n", "<leader>bf", vim.lsp.buf.format, { desc = "Format buffer" })

-- buffer commands
map("n", "<leader>bd", function() Snacks.bufdelete.delete() end, { desc = "Close buffer" })

-- notifications
map("n", "<leader>d", function() Snacks.notifier.hide() end, { desc = "Dismiss notifications" })

-- lsp mappings
map("n", "<leader>lx", function()
	vim.lsp.stop_client(vim.lsp.get_clients({bufnr=vim.api.nvim_get_current_buf()}))
end, { desc = "Stop lsp clients" })
