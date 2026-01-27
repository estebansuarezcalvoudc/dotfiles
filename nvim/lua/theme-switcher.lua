local M = {}

-- Función para detectar el tema del sistema
function M.get_theme()
  -- Leer desde el archivo de configuración
  local file = io.open(os.getenv("HOME") .. "/.config/theme-mode", "r")
  
  if file then
    local theme = file:read("*all"):gsub("%s+", "") -- Eliminar espacios/saltos
    file:close()
    return theme
  end
  
  -- Por defecto, usar dark
  return "dark"
end

-- Función para aplicar highlight groups personalizados según el tema
function M.apply_custom_highlights()
  local theme = M.get_theme()
  
  if theme == "light" then
    -- Ajustes para tema claro - notificaciones más oscuras y legibles
    vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = "#1e66f5", bold = true })
    vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#1e66f5" })
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = "#1e66f5" })
    vim.api.nvim_set_hl(0, "NotifyINFOBody", { fg = "#4c4f69", bg = "#e6e9ef" })
    
    vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = "#df8e1d", bold = true })
    vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#df8e1d" })
    vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = "#df8e1d" })
    vim.api.nvim_set_hl(0, "NotifyWARNBody", { fg = "#4c4f69", bg = "#e6e9ef" })
    
    vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = "#d20f39", bold = true })
    vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#d20f39" })
    vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#d20f39" })
    vim.api.nvim_set_hl(0, "NotifyERRORBody", { fg = "#4c4f69", bg = "#e6e9ef" })
    
    vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#7287fd", bold = true })
    vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#7287fd" })
    vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#7287fd" })
    vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { fg = "#4c4f69", bg = "#e6e9ef" })
    
    vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#8839ef", bold = true })
    vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#8839ef" })
    vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#8839ef" })
    vim.api.nvim_set_hl(0, "NotifyTRACEBody", { fg = "#4c4f69", bg = "#e6e9ef" })
  end
end

-- Función para aplicar el tema
function M.apply_theme()
  local theme = M.get_theme()
  
  if theme == "light" then
    vim.cmd.colorscheme("catppuccin-latte")
  else
    vim.cmd.colorscheme("catppuccin-mocha")
  end
  
  -- Aplicar highlights personalizados después del colorscheme
  vim.schedule(function()
    M.apply_custom_highlights()
  end)
  
  print("🎨 Tema aplicado: " .. theme)
end

-- Función para recargar el tema (llamada desde el script externo)
function M.reload()
  M.apply_theme()
end

return M
