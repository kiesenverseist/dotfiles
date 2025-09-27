return {
	{
		'saghen/blink.cmp',
		dependencies = {
			'Kaiser-Yang/blink-cmp-avante',
		},
		opts = {
			sources = {
				providers = {
					avante = {
						module = 'blink-cmp-avante',
						name = 'Avante',
						opts = {
							-- options for blink-cmp-avante
						}
					}
				},
			}
		}
	},
	{
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		opts = {
			window = { position = "float", },
		},
	},
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			-- add any opts here
			-- this file can contain specific instructions for your project
			instructions_file = "avante.md",
			-- for example
			provider = "ollama",--"claude",
			providers = {
				claude = {
					endpoint = "https://api.anthropic.com",
					model = "claude-sonnet-4-20250514",
					timeout = 30000, -- Timeout in milliseconds
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 20480,
					},
				},
				ollama = {
					endpoint = "http://graphite:11434",
					model = "gpt-oss:20b",
					-- model = "qwen2.5-coder:14b",
				},
			},
			input = {
				provider = "snacks",
				provider_opts = {
					-- Additional snacks.input options
					title = "Avante Input",
					icon = " ",
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- {
			-- 	-- support for image pasting
			-- 	"HakonHarnes/img-clip.nvim",
			-- 	event = "VeryLazy",
			-- 	opts = {
			-- 		-- recommended settings
			-- 		default = {
			-- 			embed_image_as_base64 = false,
			-- 			prompt_for_file_name = false,
			-- 			drag_and_drop = {
			-- 				insert_mode = true,
			-- 			},
			-- 			-- required for Windows users
			-- 			use_absolute_path = true,
			-- 		},
			-- 	},
			-- },
		},
	}
}
