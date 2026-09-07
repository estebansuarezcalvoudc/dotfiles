local M = {}

-- Lee la paleta del tema actual de Omarchy y la aplica a aether.nvim, de
-- modo que nvim siga EXACTAMENTE el tema activo (no solo claro/oscuro).
local OMARCHY_COLORS = os.getenv("HOME") .. "/.local/state/omarchy/current/theme/colors.toml"

local last_colors_mtime = nil

-- Parsea colors.toml (líneas `clave = "valor"`) a una tabla Lua.
function M.parse_colors()
  local colors = {}
  local file = io.open(OMARCHY_COLORS, "r")

  if file then
    local content = file:read("*all")
    file:close()

    for key, value in content:gmatch('(%S+)%s*=%s*"([^"]+)"') do
      colors[key] = value
    end
  end

  return colors
end

-- Construye la paleta esperada por aether a partir de colors.toml,
-- añadiendo los alias que resuelve `omarchy-theme-color --all`.
function M.build_aether_palette(c)
  local palette = {
    bg = c.background,
    dark_bg = c.dark_background,
    darker_bg = c.darker_background,
    lighter_bg = c.lighter_background,

    fg = c.foreground,
    dark_fg = c.dark_foreground,
    light_fg = c.light_foreground,
    bright_fg = c.bright_foreground,
    muted = c.muted,

    red = c.red,
    yellow = c.yellow,
    orange = c.orange,
    green = c.green,
    cyan = c.cyan,
    blue = c.blue,
    magenta = c.magenta,
    purple = c.magenta,
    brown = c.brown,

    bright_red = c.bright_red,
    bright_yellow = c.bright_yellow,
    bright_green = c.bright_green,
    bright_cyan = c.bright_cyan,
    bright_blue = c.bright_blue,
    bright_magenta = c.bright_magenta,
    bright_purple = c.bright_magenta,

    accent = c.accent,
    cursor = c.bright_foreground,
    foreground = c.foreground,
    background = c.background,
    selection = c.selection,
    selection_foreground = c.foreground,
    selection_background = c.selection,
  }
  return palette
end

-- Aplica highlights personalizados usando la paleta del tema activo,
-- para que las notificaciones sean legibles tanto en claro como en oscuro.
function M.apply_custom_highlights(c)
  local c = c or M.parse_colors()

  local bg = c.background or "#eff1f5"
  local fg = c.foreground or "#4c4f69"
  local info = c.blue or "#1e66f5"
  local warn = c.yellow or "#df8e1d"
  local error = c.red or "#d20f39"
  local debug = c.bright_magenta or c.magenta or "#ea76cb"
  local trace = c.magenta or "#ea76cb"

  vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = info, bold = true })
  vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = info })
  vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = info })
  vim.api.nvim_set_hl(0, "NotifyINFOBody", { fg = fg, bg = bg })

  vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = warn, bold = true })
  vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = warn })
  vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = warn })
  vim.api.nvim_set_hl(0, "NotifyWARNBody", { fg = fg, bg = bg })

  vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = error, bold = true })
  vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = error })
  vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = error })
  vim.api.nvim_set_hl(0, "NotifyERRORBody", { fg = fg, bg = bg })

  vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = debug, bold = true })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = debug })
  vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = debug })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { fg = fg, bg = bg })

  vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = trace, bold = true })
  vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = trace })
  vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = trace })
  vim.api.nvim_set_hl(0, "NotifyTRACEBody", { fg = fg, bg = bg })
end

-- Aplica el tema: configura aether con la paleta exacta del tema Omarchy.
function M.apply_theme()
  local c = M.parse_colors()
  local palette = M.build_aether_palette(c)

  require("aether").setup({ colors = palette })
  vim.cmd.colorscheme("aether")

  -- Aplicar highlights personalizados después del colorscheme
  vim.schedule(function()
    M.apply_custom_highlights(c)
  end)
end

-- Recarga el tema (usado desde el watcher y scripts externos).
function M.reload()
  M.apply_theme()
end

-- Vigila colors.toml y re-aplica el tema cuando Omarchy cambia de tema,
-- permitiendo que nvim siga a Omarchy sin reiniciarlo.
local uv = vim.uv or vim.loop

local function colors_mtime()
  local stat = uv.fs_stat(OMARCHY_COLORS)
  return stat and stat.mtime.sec or nil
end

function M.start_watcher()
  last_colors_mtime = colors_mtime()

  vim.fn.timer_start(2000, function()
    local mtime = colors_mtime()
    if mtime and mtime ~= last_colors_mtime then
      last_colors_mtime = mtime
      vim.schedule(function()
        M.apply_theme()
      end)
    end
  end, { ["repeat"] = -1 })
end

return M