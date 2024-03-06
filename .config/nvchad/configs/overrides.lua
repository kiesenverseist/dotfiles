local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
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
	extensions_list = { "project", "themes", "terms", "zoxide", "undo" },
	extensions = {
		project = {
			sync_with_nvim_tree = true,
		},
		zoxide = {},
		undo = {
			use_delta = true,
			side_by_side = true,
		},
	},
}

local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
	M.cmp = {
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),
			["<C-y>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			["<CR>"] = nil,
			["<Tab>"] = cmp.mapping(function(fallback)
				if require("luasnip").expand_or_jumpable() then
					vim.fn.feedkeys(
						vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
						""
					)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if require("luasnip").jumpable(-1) then
					vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		},
	}
end

return M
