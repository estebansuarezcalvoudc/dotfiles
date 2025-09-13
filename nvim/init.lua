---@diagnostic disable: undefined-global
require("config.lazy")

-- Global defaults: 4 spaces
vim.o.expandtab = true
 vim.o.tabstop = 4
 vim.o.shiftwidth = 4
 vim.o.softtabstop = 4

-- Specific overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"lua", "javascript", "typescript", "javascriptreact", "typescriptreact"},
  callback = function()
   vim.bo.expandtab = true     -- use spaces
   vim.bo.tabstop = 2          -- number of spaces per tab
   vim.bo.shiftwidth = 2       -- number of spaces for auto-indent
   vim.bo.softtabstop = 2
  end
})
