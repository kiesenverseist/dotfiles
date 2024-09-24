local base_on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local function on_attach(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end

  base_on_attach(client, bufnr)
end

-- if you just want default config for the servers then put them in a table
local servers = {
  -- webdev stuff
  "html",
  -- "cssls",
  "ts_ls",
  "tailwindcss",
  "svelte",
  "prismals",
  "htmx",

  "clangd",
  "rust_analyzer",

  -- "pylsp",
  -- "pyright",
  "basedpyright",

  "gdscript",
  "nixd",
  "regols",

  "gopls",
  "templ",
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

lspconfig.lua_ls.setup {
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

lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "*.k8s.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
        ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
        ["https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/master/src/main/resources/schemas/bitbucket-pipelines.schema.json"] = "*bitbucket-pipelines*.{yml, yaml}",
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      },
    },
  },
}

lspconfig.ocamllsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,

  settings = {
    codeLens = { enable = true },
    inlayHints = { enable = true },
  },
}

lspconfig.ruff.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    client.server_capabilities.hoverProvider = false
  end,
  on_init = on_init,
  capabilities = capabilities,
}

require("neodev").setup {}

-- to get rid of the no information popups when multiple lsps are used
-- https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
-- vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
--   config = config or {}
--   config.focus_id = ctx.method
--   if not (result and result.contents) then
--     return
--   end
--   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
--   markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
--   if vim.tbl_isempty(markdown_lines) then
--     return
--   end
--   return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
-- end
