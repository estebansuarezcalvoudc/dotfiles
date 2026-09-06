-- Navegación tipo pila LIFO sobre buffers visitados (historial con truncado,
-- como el back/forward de un navegador).
--   <leader>j = subir en la pila (anterior)
--   <leader>k = bajar en la pila (siguiente)
-- Al abrir un buffer "a mano" desde el medio de la pila, se descartan las
-- entradas que estaban por delante.

local M = {}

local stack = {}    -- array de bufnrs, en orden de visita
local idx = 0       -- posición actual dentro de stack
local navigating = false -- true mientras nosotros hacemos el :buffer

local function tracked(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return false end
  -- solo buffers "normales" listados (extermi terminals, qf, prompts, floats, neo-tree...)
  if vim.bo[bufnr].buftype ~= "" then return false end
  if not vim.bo[bufnr].buflisted then return false end
  return true
end

local function position(bufnr)
  for i, b in ipairs(stack) do
    if b == bufnr then return i end
  end
end

-- conserva lo anterior a idx (sin duplicados) y descarta el futuro
local function push(bufnr)
  local kept = {}
  for i, b in ipairs(stack) do
    if i <= idx and b ~= bufnr then kept[#kept + 1] = b end
  end
  kept[#kept + 1] = bufnr
  stack = kept
  idx = #stack
end

local function go_to(i)
  if i < 1 or i > #stack then return end
  local buf = stack[i]
  if not vim.api.nvim_buf_is_valid(buf) then
    table.remove(stack, i)
    if i < idx then idx = idx - 1 end
    return go_to(i) -- reintenta en la nueva posición
  end
  navigating = true
  pcall(vim.cmd, "buffer " .. buf)
  navigating = false
  idx = i
end

function M.back() go_to(idx - 1) end
function M.forward() go_to(idx + 1) end

function M.setup()
  vim.api.nvim_create_autocmd("BufEnter", {
    desc = "buffer-stack: track visited buffers",
    callback = function(ev)
      if navigating then return end
      if not tracked(ev.buf) then return end
      if position(ev.buf) == idx then return end
      push(ev.buf)
    end,
  })

  -- si cierras un buffer, quítalo de la pila
  vim.api.nvim_create_autocmd("BufDelete", {
    desc = "buffer-stack: drop closed buffers",
    callback = function(ev)
      local p = position(ev.buf)
      if not p then return end
      table.remove(stack, p)
      if p < idx then
        idx = idx - 1
      elseif p == idx then
        idx = math.min(idx, #stack)
      end
    end,
  })

  vim.keymap.set("n", "<leader>j", M.back,
    { desc = "Pila de buffers: anterior" })
  vim.keymap.set("n", "<leader>k", M.forward,
    { desc = "Pila de buffers: siguiente" })

  -- semilla con el buffer actual si ya hay uno (ojo: guardar el número real,
  -- no 0, que es un manejador relativo que luego apunta a otro buffer)
  local cur = vim.api.nvim_get_current_buf()
  if tracked(cur) then push(cur) end
end

-- para depurar/inspeccionar desde Lua: require("config.bufstack")._debug()
function M._debug()
  local names = {}
  for i, b in ipairs(stack) do
    names[i] = (i == idx and "*" or " ") .. vim.fn.bufname(b)
  end
  return names
end

return M
