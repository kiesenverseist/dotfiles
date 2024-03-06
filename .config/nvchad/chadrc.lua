---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "gruvchad",
	theme_toggle = { "gruvchad", "tokyonight" },
	transparency = true,
	hl_override = highlights.override,
	hl_add = highlights.add,
	statusline = {
		-- theme = "vscode_colored",
		-- theme = "default",
		-- separator_style = "default",
		overriden_modules = function(modules)
			local cursor_position = function()
				local left_sep = "%#St_pos_sep#" .. "" .. "%#St_pos_icon#" .. " "
				return left_sep .. "%#St_pos_text#" .. " " .. "%l:%c" .. " "
			end
			table.remove(modules, 10)
			table.insert(modules, cursor_position())
		end,
	},
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
