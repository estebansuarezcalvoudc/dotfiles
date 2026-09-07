return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				theme = "aether",
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})

		-- Mover la statusline arriba
		vim.o.laststatus = 3
		vim.o.winbar = "%{%v:lua.require'lualine'.statusline()%}"
		vim.o.laststatus = 0
	end,
}
