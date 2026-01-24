return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Python (usa las herramientas instaladas por Mason)
				null_ls.builtins.formatting.ruff, -- Organiza imports + formatea
				null_ls.builtins.formatting.black, -- Alternativa de formateo
				null_ls.builtins.diagnostics.ruff, -- Detecta errores

				-- JavaScript/TypeScript
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.code_actions.eslint_d,

				-- Lua
				null_ls.builtins.formatting.stylua,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format file" })

		-- ✨ Organizar imports (funciona para Python, TS, JS, etc.)
		vim.keymap.set("n", "<leader>ri", function()
			vim.lsp.buf.format({ async = false })
		end, { desc = "Organize imports" })
	end,
}
