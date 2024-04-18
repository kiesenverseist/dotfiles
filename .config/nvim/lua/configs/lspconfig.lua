local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  -- "cssls",
  "tsserver",
  "tailwindcss",
  "svelte",
  "clangd",
  "rust_analyzer",
  -- "pylsp",
  "pyright",
  -- "ruff_lsp",
  "gdscript",
  "nixd",
  "prismals",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

lspconfig.cssls.setup {
  cmd = { "css-languageserver", "--stdio" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

lspconfig.texlab.setup {
  settings = {
    textlab = {
      build = {
        executable = "tectonic",
        args = { "--synctex", "--keep-logs", "--keep-intermediates", "main.tex" },
      },
    },
  },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

lspconfig.ltex.setup {
  settings = {
    ltex = {
      language = "en-AU",
    },
  },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

--
-- lspconfig.rust_analyzer.setup({
--   cmd = { "rust-analyzer" },
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- })

-- from: require("nvchad.configs.lspconfig").defaults()
dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

require("lspconfig").lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  -- before_init = require("neodev.lsp").before_init,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

require("neodev").setup {}
