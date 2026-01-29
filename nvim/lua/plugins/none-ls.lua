return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvimtools/none-ls-extras.nvim", -- Para eslint_d
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			timeout_ms = 10000,

			sources = {
				-- Python
				null_ls.builtins.formatting.black,

				-- JavaScript/TypeScript
				null_ls.builtins.formatting.prettier,
				require("none-ls.diagnostics.eslint_d"), -- Desde none-ls-extras
				require("none-ls.code_actions.eslint_d"),

				-- Lua
				null_ls.builtins.formatting.stylua,
			},
		})

		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({ timeout_ms = 10000 })
		end, { desc = "Format file" })

		-- Organizar imports con code actions
		vim.keymap.set("n", "<leader>go", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { "source.organizeImports" },
				},
			})
		end, { desc = "Organize imports" })
	end,
}
