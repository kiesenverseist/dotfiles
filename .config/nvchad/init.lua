local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

if vim.g.neovide == true then
  vim.o.guifont = "FiraCode Nerd Font:h14"
  vim.o.winblend = 50
  vim.o.pumblend = 50

  vim.g.neovide_transparency = 0.95
  vim.g.transparency = 0.95

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end

local opt = vim.opt
local api = vim.api

-- Indenting
-- opt.expandtab = true
-- opt.shiftwidth = 4
-- opt.smartindent = true
-- opt.tabstop = 4
-- opt.softtabstop = 4

-- code folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

local function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command('augroup '..group_name)
        api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            api.nvim_command(command)
        end
        api.nvim_command('augroup END')
    end
end


local autoCommands = {
    -- other autocommands
    open_folds = {
        {"BufEnter", "*", "normal zR"}
    }
}

nvim_create_augroups(autoCommands)

-- vimtex config (move to separete file later)
vim.g.vimtex_mappings_prefix = '<S-Space>'
vim.g.vimtex_compiler_method = "tectonic"
vim.g.vimtex_view_method = 'zathura'
vim.g.maplocalleader = ','

-- hypr treesitter stuff
-- local parser_config = require("nvim-treesitter.parsers").get_parser_config()
-- parser_config.hypr = {
--   install_info = {
--     url = "https://github.com/luckasRanarison/tree-sitter-hypr",
--     files = { "src/parser.c" },
--     branch = "master",
--   },
--   filetype = "hypr",
-- }
