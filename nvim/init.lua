require("config.lazy")

-- Sync clipboard with system
vim.opt.clipboard = "unnamedplus"

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

-- Move current line up/down with Alt+Arrow
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Tab out
vim.keymap.set("i", "<Tab>", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local next_char = line:sub(col, col)

  -- Characters you want to "tab out" of
  local tabout_chars = { [")"] = true, ["}"] = true, ["]"] = true, [";"] = true, ['"'] = true, ["'"] = true }

  if tabout_chars[next_char] then
    return "<Right>"
  else
    return "<Tab>"
  end
end, { expr = true, noremap = true })

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
