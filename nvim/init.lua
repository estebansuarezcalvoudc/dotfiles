require("config.lazy")

-- Sync clipboard with system
vim.opt.clipboard = "unnamedplus"

-- Mantener signcolumn siempre invisible (evita el desplazamiento)
vim.opt.signcolumn = "no"  -- Opciones: "yes", "no", "auto", "yes:1", "yes:2"

-- Global defaults: 4 spaces
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Specific overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.bo.expandtab = true -- use spaces
    vim.bo.tabstop = 2    -- number of spaces per tab
    vim.bo.shiftwidth = 2 -- number of spaces for auto-indent
    vim.bo.softtabstop = 2
  end,
})

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Move current line up/down with Alt+Arrow
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Tab out (esto se maneja ahora en completions.lua para evitar conflictos con nvim-cmp)
-- El mapping de Tab en completions.lua tiene prioridad

-- NORMAL mode
vim.keymap.set("n", "<Tab>", ">>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", "<<", { noremap = true, silent = true })

-- VISUAL mode (keep selection after indent/de-indent)
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- INSERT mode
-- Shift-Tab de-indents
vim.keymap.set("i", "<S-Tab>", function()
  return "<C-d>"
end, { expr = true, noremap = true })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>n", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { noremap = true, silent = true, desc = "Toggle relative line numbers" })

-- Comando :Keymaps para buscar atajos
vim.api.nvim_create_user_command('Keymaps', function()
  require('telescope.builtin').keymaps()
end, { desc = "Search keymaps with Telescope" })
