---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
-- local highlights = require "nvchad.configs.highlights"

M.ui = {
  theme = "rosepine",
  theme_toggle = { "rosepine", "tokyonight" },
  -- transparency = true,
  hl_override = require("highlights").override,
  hl_add = require("highlights").add,

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

  term = {
    float = {
      relative = "editor",
      row = 0.1,
      col = 0.1,
      width = 0.8,
      height = 0.7,
      border = "single",
    },
  },
}

-- M.plugins = "custom.plugins"

-- check core.mappings for table structure
-- M.mappings = require("custom.mappings")

return M
