return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			-- Aplicar tema dinámicamente
			local theme_switcher = require("theme-switcher")
			theme_switcher.apply_theme()

			-- Opcional: Crear comando para cambiar el tema desde nvim
			vim.api.nvim_create_user_command("ThemeToggle", function()
				-- Cambiar el tema manualmente desde nvim
				local current = theme_switcher.get_theme()
				local new_theme = current == "dark" and "light" or "dark"

				-- Guardar
				local file = io.open(os.getenv("HOME") .. "/.config/theme-mode", "w")
				if file then
					file:write(new_theme)
					file:close()
				end

				-- Aplicar
				theme_switcher.apply_theme()
			end, {})
		end,
	},
}
