local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = {
    "html", "cssls", "tsserver", "svelte",
    "clangd", --"rust_analyzer",
    "pylsp",
    "gdscript",
    "nixd",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- 
lspconfig.texlab.setup {
  settings = {
    textlab = {
      build = {
        executable = "tectonic",
        args = {"--synctex", "--keep-logs", "--keep-intermediates", "main.tex"},
      }
    }
  },
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.rust_analyzer.setup {
  -- cmd = {"/nix/store/sri7b1jjipg8i0yql90xbr1c12ij7m02-rust-analyzer-2023-07-17/bin/rust-analyzer"},
  cmd = {"rust-analyzer"},
  on_attach = on_attach,
  capabilities = capabilities,
}
