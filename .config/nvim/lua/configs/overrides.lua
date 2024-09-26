local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "vimdoc",
    "query",
    "lua",
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "svelte",
    "markdown",
    "markdown_inline",
    "latex",
    "c",
    "cpp",
    "cmake",
    "make",
    "rust",
    "fish",
    "bash",
    "yaml",
    "toml",
    "json",
    "nix",
    "ocaml",
    "ocaml_interface",
    "python",
    "java",
    "regex",
    "gdscript", --"gdresource",
    "gitignore",
    "gitattributes",
    "git_rebase",
    "gitcommit",
    "git_config",
    "hyprlang",
    "go",
    "templ",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ia"] = { query = "@parameter.inner", desc = "Select inside argument" },
        ["aa"] = { query = "@parameter.outer", desc = "Select around argument" },
        ["if"] = { query = "@function.inner", desc = "Select inside function" },
        ["af"] = { query = "@function.outer", desc = "Select around function" },
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "v",
      node_decremental = "V",
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "svelte-language-server",

    -- c/cpp stuff
    "clangd",
    "clang-format",
    "cpptools",

    "rust-analyzer",

    "shell-check",
    "black",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.telescope = {
  extensions_list = { "themes", "terms", "zoxide", "undo" },
  extensions = {
    zoxide = {},
    undo = {
      use_delta = true,
      side_by_side = true,
    },
  },
}

return M
