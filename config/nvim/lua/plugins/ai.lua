local toggle_key = "<C-,>"
return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		keys = {
			{ toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "x" } },
		},
		opts = {
			terminal_cmd = "direnv exec . claude",
			terminal = {
				---@module "snacks"
				---@type snacks.win.Config|{}
				snacks_win_opts = {
					position = "float",
					width = 0.9,
					height = 0.9,
					keys = {
						claude_hide = {
							toggle_key,
							function(self) self:hide() end,
							mode = "t",
							desc = "Hide",
						},
					},
				},
			},
			diff_opts = {
				open_in_current_tab = false,
				-- keep_terminal_focus = true,
			},
		},
	},
	-- {
	-- 	'saghen/blink.cmp',
	-- 	dependencies = {
	-- 		'Kaiser-Yang/blink-cmp-avante',
	-- 	},
	-- 	opts = {
	-- 		sources = {
	-- 			providers = {
	-- 				avante = {
	-- 					module = 'blink-cmp-avante',
	-- 					name = 'Avante',
	-- 					opts = {
	-- 						-- options for blink-cmp-avante
	-- 					}
	-- 				}
	-- 			},
	-- 		}
	-- 	}
	-- },
	-- {
	-- 	"greggh/claude-code.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim", -- Required for git operations
	-- 	},
	-- 	opts = {
	-- 		window = {
	-- 			position = "float",
	-- 			float = {
	-- 				width = "90%",
	-- 				height = "90%",
	-- 			},
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"yetone/avante.nvim",
	-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- 	-- ⚠️ must add this setting! ! !
	-- 	build = "make",
	-- 	event = "VeryLazy",
	-- 	version = false, -- Never set this value to "*"! Never!
	-- 	---@module 'avante'
	-- 	---@type avante.Config
	-- 	opts = {
	-- 		-- add any opts here
	-- 		-- this file can contain specific instructions for your project
	-- 		instructions_file = "avante.md",
	-- 		-- for example
	-- 		provider = "ollama",
	-- 		-- provider = "claude",
	-- 		auto_suggestions_provider = "ollama",
	-- 		providers = {
	-- 			claude = {
	-- 				endpoint = "https://api.anthropic.com",
	-- 				model = "claude-sonnet-4-20250514",
	-- 				timeout = 30000, -- Timeout in milliseconds
	-- 				extra_request_body = {
	-- 					temperature = 0.75,
	-- 					max_tokens = 20480,
	-- 				},
	-- 			},
	-- 			ollama = {
	-- 				endpoint = "http://graphite:11434",
	-- 				-- model = "gpt-oss:20b",
	-- 				-- model = "qwen2.5-coder:14b",
	-- 				-- model = "qwen2.5-coder:7b",
	-- 				-- model = "qwen3:14b",
	-- 				-- model = "devstral:latest",
	-- 				-- model = "cogito:14b",
	-- 				model = "cogito:8b",
	-- 			},
	-- 		},
	-- 		input = {
	-- 			provider = "snacks",
	-- 			provider_opts = {
	-- 				-- Additional snacks.input options
	-- 				title = "Avante Input",
	-- 				icon = " ",
	-- 			},
	-- 		},
	-- 		behaviour = {
	-- 			auto_approve_tool_permissions = false,
	-- 			auto_suggestions = true,
	-- 			auto_apply_diff_after_generation = false,
	-- 		},
	-- 	},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		-- {
	-- 		-- 	-- support for image pasting
	-- 		-- 	"HakonHarnes/img-clip.nvim",
	-- 		-- 	event = "VeryLazy",
	-- 		-- 	opts = {
	-- 		-- 		-- recommended settings
	-- 		-- 		default = {
	-- 		-- 			embed_image_as_base64 = false,
	-- 		-- 			prompt_for_file_name = false,
	-- 		-- 			drag_and_drop = {
	-- 		-- 				insert_mode = true,
	-- 		-- 			},
	-- 		-- 			-- required for Windows users
	-- 		-- 			use_absolute_path = true,
	-- 		-- 		},
	-- 		-- 	},
	-- 		-- },
	-- 	},
	-- }
}
