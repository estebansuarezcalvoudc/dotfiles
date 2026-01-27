return {
	"chikko80/error-lens.nvim",
	event = "BufRead",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		-- Función para detectar el tema actual
		local function get_theme()
			local file = io.open(os.getenv("HOME") .. "/.config/theme-mode", "r")
			if file then
				local theme = file:read("*all"):gsub("%s+", "")
				file:close()
				return theme
			end
			return "dark"
		end

		-- Configurar colores según el tema
		local theme = get_theme()
		local colors

		if theme == "light" then
			-- Colores para tema claro (Catppuccin Latte)
			colors = {
				error_fg = "#d20f39", -- rojo oscuro
				error_bg = "#f2d5d5", -- rosa muy claro
				warn_fg = "#df8e1d",  -- naranja oscuro
				warn_bg = "#f9f0e8",  -- beige muy claro
				info_fg = "#1e66f5",  -- azul
				info_bg = "#d4e0f5",  -- azul muy claro
				hint_fg = "#1e6b1e",  -- verde MÁS oscuro
				hint_bg = "#d4edd4",  -- verde claro con más contraste
			}
		else
			-- Colores para tema oscuro (Catppuccin Mocha) - originales
			colors = {
				error_fg = "#FF6363",
				error_bg = "#4B252C",
				warn_fg = "#FA973A",
				warn_bg = "#403733",
				info_fg = "#5B38E8",
				info_bg = "#281478",
				hint_fg = "#25E64B",
				hint_bg = "#147828",
			}
		end

		require("error-lens").setup({
			enabled = true,
			auto_adjust = {
				enable = false,
				fallback_bg_color = nil,
				step = 7,
				total = 30,
			},
			prefix = 4,
			colors = colors,
		})
	end,
}
