local servers = {
	"lua_ls",
	"basedpyright",
	"nixd",
	"ruff",
	"yamlls",
}

vim.api.nvim_create_user_command("LspStop", function ()
	local clients = vim.lsp.get_clients({bufnr=vim.api.nvim_get_current_buf()})
	for _, client in ipairs(clients) do
		client:stop()
	end
end, {})

vim.api.nvim_create_user_command("LspStart", function ()
	vim.lsp.enable(servers)
	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		if client.config.get_language_id == vim.bo.filetype then
			vim.lsp.buf_attach_client(client.id, vim.api.nvim_get_current_buf())
		end
	end
end, {})

vim.api.nvim_create_user_command("LspEnable", function ()
	vim.print("enabling lsp")
	vim.lsp.enable(servers)
	local clients = vim.lsp.get_clients({_uninitialized=true})
	for _, client in ipairs(clients) do
		for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
			local ft = vim.api.nvim_get_option_value("filetype",{scope="local", buf=buf_id})
			if client.config.get_language_id == ft then
				if not client.initialized then client:initialize() end
				vim.lsp.buf_attach_client(client.id, buf_id)
			end
		end
	end
end, {})
