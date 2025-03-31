-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroups

---@type Base46HLGroupsList
M.override = {
  ["@comment"] = {
    fg = { "light_grey", 16 },
    italic = true,
  },
  ["@keyword"] = { bold = true },
  ["@keyword.return"] = { bold = true },
  ["@keyword.function"] = { bold = true },
}

return M
