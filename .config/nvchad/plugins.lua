local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		opts = { inlay_hints = { enabled = true } },
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			{
				"nvim-treesitter/nvim-treesitter-context",
				-- cmd = {"TSBufEnable",},
				config = function()
					require("treesitter-context").setup()
				end,
			},
			{
				"luckasRanarison/tree-sitter-hypr",
				config = function()
					local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
					parser_config.hypr = {
						install_info = {
							url = "https://github.com/luckasRanarison/tree-sitter-hypr",
							files = { "src/parser.c" },
							branch = "master",
						},
						filetype = "hypr",
					}
				end,
			},
			{
				"HiPhish/rainbow-delimiters.nvim",
				config = function()
					require("rainbow-delimiters.setup").setup({})
				end,
			},
		},
	},

	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = overrides.telescope,
		dependencies = {
			{ "nvim-telescope/telescope-project.nvim" },
			{ "nvim-telescope/telescope-bibtex.nvim" },
			{ "jvgrootveld/telescope-zoxide" },
			{ "debugloop/telescope-undo.nvim" },
		},
	},

	{
		"nvim-telescope/telescope-project.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},

	{
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			{ "nvim-lua/popup.nvim" },
		},
	},
	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<localleader>", '"', "'", "`", "c", "v", "g", "y", "z" },
	},

	{
		"echasnovski/mini.align",
		keys = { "ga", "gA" },
		init = function()
			require("core.utils").load_mappings("minialign")
		end,
		config = function()
			require("mini.align").setup()
		end,
	},

	-- {
	--   "windwp/nvim-projectconfig",
	--   lazy = false,
	--   config = function()
	--     require("nvim-projectconfig").setup({autocmd = true})
	--   end
	-- },

	{
		"direnv/direnv.vim",
		lazy = false,
	},

	-- debugging support
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		dependencies = {
			"mfussenegger/nvim-dap-python",
			"rcarriga/nvim-dap-ui",
		},
		init = function()
			require("core.utils").load_mappings("dap")
		end,
		config = function()
			require("custom.configs.dapconfig")
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = false,
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			},
		},
		config = true,
	},

	{
		"rcarriga/nvim-notify",
		lazy = false,
		init = function()
			require("core.utils").load_mappings("notify")
		end,
		config = function()
			vim.notify = function(msg, ...)
				if
					msg:match(
						"warning: multiple different client offset_encodings detected for buffer, this is not supported yet"
					)
				then
					return
				end
				require("notify")(msg, ...)
			end
		end,
	},

	-- {
	-- 	"dccsillag/magma-nvim",
	-- 	lazy = false,
	-- 	version = "*",
	-- 	keys = {
	-- 		{ "<leader>mi", "<cmd>MagmaInit<CR>", desc = "This command initializes a runtime for the current buffer." },
	-- 		{ "<leader>mo", "<cmd>MagmaEvaluateOperator<CR>", desc = "Evaluate the text given by some operator." },
	-- 		{ "<leader>ml", "<cmd>MagmaEvaluateLine<CR>", desc = "Evaluate the current line." },
	-- 		{ "<leader>mv", "<cmd>MagmaEvaluateVisual<CR>", desc = "Evaluate the selected text." },
	-- 		{ "<leader>mc", "<cmd>MagmaEvaluateOperator<CR>", desc = "Reevaluate the currently selected cell." },
	-- 		{ "<leader>mr", "<cmd>MagmaRestart!<CR>", desc = "Shuts down and restarts the current kernel." },
	-- 		{
	-- 			"<leader>mx",
	-- 			"<cmd>MagmaInterrupt<CR>",
	-- 			desc = "Interrupts the currently running cell and does nothing if not cell is running.",
	-- 		},
	-- 	},
	-- 	build = ":UpdateRemotePlugins",
	-- 	-- event="BufEnter",
	-- 	-- config = function()
	-- 	--     -- vim.cmd[[:UpdateRemotePlugins]]
	-- 	--     require('magma').setup()
	-- 	-- end
	-- },
	{
		"lervag/vimtex",
		lazy = false,
	},
	{
		"elkowar/yuck.vim",
		ft='yuck',
	},
	{
		"gpanders/nvim-parinfer",
    ft='yuck',
	},

	-- obsidian
	{
		"epwalsh/obsidian.nvim",
		lazy = true,
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/knowledge/**.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/knowledge/**.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
		opts = {
			dir = "~/knowledge", -- no need to call 'vim.fn.expand' here
			-- Optional, key mappings.
			mappings = {
				-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
				-- ["gf"] = require("obsidian.mapping").gf_passthrough(),
			},
			-- see below for full list of options 👇
		},
		-- config = function()
		--   require("obsidian").setup()
		-- end
		init = function()
			require("core.utils").load_mappings("obsidian")
		end,
	},
	-- {
	--   "oflisback/obsidian-sync.nvim",
	--   config = function() require("obsidian-sync").setup() end,
	--   lazy = false,
	-- },
	{
		"amitds1997/remote-nvim.nvim",
		lazy = false,
		version = "*", -- This keeps it pinned to semantic releases
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			-- This would be an optional dependency eventually
			"nvim-telescope/telescope.nvim",
		},
		-- config = true, -- This calls the default setup(); make sure to call it
		config = function()
			require("remote-nvim").setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("custom.configs.conform")
		end,
	},
	{ "folke/neodev.nvim", opts = {} },

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- keys = { "<leader>T" },
		lazy = false,
		opts = { },
		init = function()
			require("core.utils").load_mappings("trouble")
		end,
	},
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		-- add any options here
	-- 	},
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"rcarriga/nvim-notify",
	-- 	},
	-- },
	require("custom.configs.neotestconfig"),
	{
		"andythigpen/nvim-coverage",
		event = "BufEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
	{
		"NvChad/nvterm",
		opts = overrides.nvterm,
	},
}

return plugins
