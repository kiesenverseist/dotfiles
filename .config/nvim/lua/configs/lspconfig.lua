local nvlsp = require "nvchad.configs.lspconfig"

nvlsp.defaults()

local on_init = nvlsp.on_init
local capabilities = nvlsp.capabilities

local lspconfig = require "lspconfig"

local function on_attach(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end

  nvlsp.on_attach(client, bufnr)
end

-- Start lsp only after direnv.nvim is finished
vim.api.nvim_create_autocmd("User", {
  pattern = { "DirenvLoaded", "DirenvNotFound" }, -- this starts the lsp when the direnv was loaded or when there is no .envrc found
  callback = function()
    vim.cmd "LspStart"
  end,
})

local function setup_lsp(client, opts)
  vim.tbl_deep_extend("keep", opts, {
    autostart = false,
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })

  lspconfig[client].setup(opts)
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

  "gleam",
}

for _, lsp in ipairs(servers) do
  setup_lsp(lsp, {})
end

setup_lsp("cssls", {
  cmd = { "css-languageserver", "--stdio" },
})

setup_lsp("texlab", {
  settings = {
    textlab = {
      build = {
        executable = "tectonic",
        args = { "--synctex", "--keep-logs", "--keep-intermediates", "main.tex" },
      },
    },
  },
})

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
  autostart = false,
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

setup_lsp("yamlls", {
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
})

setup_lsp("ocamllsp", {
  settings = {
    codeLens = { enable = true },
    inlayHints = { enable = true },
  },
})

setup_lsp("ruff", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    client.server_capabilities.hoverProvider = false
  end,
})

-- require("neodev").setup {}

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
