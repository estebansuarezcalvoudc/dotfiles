return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "ts_ls", "tailwindcss" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- ✨ Nueva API de Neovim 0.11: vim.lsp.config
			-- Configuración por defecto para todos los servers
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Configuraciones específicas por server
			vim.lsp.config.lua_ls = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" }, -- Reconocer 'vim' como global
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}

			vim.lsp.config.pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
						},
					},
				},
			}

			vim.lsp.config.ts_ls = {
				settings = {
					typescript = {
						-- ✨ AGREGAR ESTAS LÍNEAS
						diagnostics = {
							ignoredCodes = {},
						},
						validate = {
							enable = true,
						},
						-- FIN DE LAS LÍNEAS NUEVAS
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						-- ✨ AGREGAR ESTAS LÍNEAS
						diagnostics = {
							ignoredCodes = {},
						},
						validate = {
							enable = true,
						},
						-- FIN DE LAS LÍNEAS NUEVAS
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			}

			-- Habilitar los LSP servers
			vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "tailwindcss" })

			-- LSP Keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
			vim.keymap.set("n", "<leader>u", require("telescope.builtin").lsp_references, { desc = "Find usages/references" })

			-- Fix all problems
			vim.keymap.set("n", "<leader>ri", function()
				vim.lsp.buf.code_action({
					context = {
						only = { "source.fixAll" },
						diagnostics = {},
					},
					apply = true,
				})
				vim.notify("✓ Applied all fixes", vim.log.levels.INFO)
			end, { desc = "Fix all problems" })
		end,
	},
}
