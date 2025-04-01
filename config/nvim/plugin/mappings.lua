-- Mappings that don't require any plugins

local map = vim.keymap.set

map("n", "<esc>", "<cmd>nohlsearch<CR>")

map("t", "<esc><esc>", "<C-\\><C-n>", { desc = 'Exit terminal mode' })
map("t", "<C-[><C-[>", "<C-\\><C-n>", { desc = 'Exit terminal mode' })

-- go to tab
map({ "n", "i", "t" }, "<M-q>", "<cmd>tabnext 1<CR>")
map({ "n", "i", "t" }, "<M-w>", "<cmd>tabnext 2<CR>")
map({ "n", "i", "t" }, "<M-e>", "<cmd>tabnext 3<CR>")

-- formatting
map("n", "<leader>bf", vim.lsp.buf.format, { desc = "Format buffer" })

-- lsp mappings
map("n", "<leader>lx", "<cmd>LspStop<cr>", { desc = "Stop lsp clients" }) -- run custom lsp command
map("n", "<leader>lwl", function() vim.print(vim.lsp.buf.list_workspace_folders()) end, { desc = "[l]ist workspaces" })
map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "[a]dd workspace" })
map("n", "<leader>lwr", function()
	vim.ui.select(
		vim.lsp.buf.list_workspace_folders(),
		{ prompt = "select workspace to delete" },
		function(ws) vim.lsp.buf.remove_workspace_folder(ws) end
	)
end, { desc = "[r]emove workspace" })
