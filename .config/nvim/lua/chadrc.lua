---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "highlights"

M.base46 = {
  theme = "flexoki",
  theme_toggle = { "flexoki", "gruvbox" },
  -- transparency = true,
  hl_override = highlights.override,
  hl_add = highlights.add,

  integrations = { "dap", "todo" },
}

M.ui = {
  statusline = {
    -- theme = "vscode_colored",
    theme = "default",
    -- separator_style = "default",

    -- overidden_modlesd = function(modules)
    --   local cursor_position = function()
    --     local left_sep = "%#St_pos_sep#" .. "" .. "%#St_pos_icon#" .. " "
    --     return left_sep .. "%#St_pos_text#" .. " " .. "%l:%c" .. " "
    --   end
    --   -- table.remove(modules, 10
    --   table.insert(modules, 10, cursor_position())
    --   table.insert(modules, 2, function()
    --     local path = vim.api.nvim_buf_get_name(0):match "^.*/"
    --     return "%#St_LspStatus#" .. path -- https://github.com/NvChad/base46/blob/v2.0/lua/base46/integrations/statusline.lua
    --   end)()
    --
    --   return modules
    -- end,
  },
}

M.term = {
  float = {
    relative = "editor",
    row = 0.1,
    col = 0.1,
    width = 0.8,
    height = 0.7,
    border = "single",
  },
}

return M
