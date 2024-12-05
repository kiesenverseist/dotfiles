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
    theme = "vscode_colored",
    -- order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd" },
    modules = {
      file = function()
        local icon = "󰈚"
        local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
        local raw_path = vim.api.nvim_buf_get_name(bufnr)
        local path = (raw_path == "" and "Empty") or raw_path
        local name = raw_path:match "([^/\\]+)[/\\]*$"

        if path ~= "Empty" then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and ft_icon) or icon
          end
        end

        return table.concat { "%#StText# ", icon, " ", "%f" }
      end,
    },
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
