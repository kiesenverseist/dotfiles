local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = {
	"html",
	-- "cssls",
	"tsserver",
	"tailwindcss",
	"svelte",
	"clangd",
	--"rust_analyzer",
	-- "pylsp",
	"pyright",
	-- "ruff_lsp",
	"gdscript",
	"nixd",
	"prismals",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.cssls.setup({
	cmd = { "css-languageserver", "--stdio" },
	on_attach = on_attach,
	capabilities = capabilities,
})
--
lspconfig.texlab.setup({
	settings = {
		textlab = {
			build = {
				executable = "tectonic",
				args = { "--synctex", "--keep-logs", "--keep-intermediates", "main.tex" },
			},
		},
	},
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
	cmd = { "rust-analyzer" },
	on_attach = on_attach,
	capabilities = capabilities,
})
--
-- lspconfig.prismals.setup({
-- 	cmd = { "npx", "prisma-language-server", "--stdio" },
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })
