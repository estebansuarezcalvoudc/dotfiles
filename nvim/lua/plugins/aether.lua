return {
	{
		"bjarneo/aether.nvim",
		branch = "v3",
		name = "aether",
		lazy = false,
		priority = 1000,
		config = function()
			-- Aplica aether con la paleta EXACTA del tema activo de Omarchy
			local theme_switcher = require("theme-switcher")
			theme_switcher.apply_theme()
			-- Re-aplicar automáticamente cuando Omarchy cambia el tema
			theme_switcher.start_watcher()
		end,
	},
}