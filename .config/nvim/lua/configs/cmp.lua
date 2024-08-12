-- return require "nvchad.configs.cmp"

local cmp = require "cmp"

local custom = {
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-y>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    ["<C-k>"] = cmp.mapping(function()
      if require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      end
    end, { "i", "s" }),

    ["<C-j>"] = cmp.mapping(function()
      if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      end
    end, { "i", "s" }),
    -- ["<Tab>"] = cmp.mapping(function(fallback)
    --   if require("luasnip").expand_or_jumpable() then
    --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
    --   else
    --     fallback()
    --   end
    -- end, { "i", "s" }),
    --
    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
    --   if require("luasnip").jumpable(-1) then
    --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
    --   else
    --     fallback()
    --   end
    -- end, { "i", "s" }),
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}

local base = require "nvchad.configs.cmp"

base.mapping = nil

return vim.tbl_deep_extend("force", base, custom)
