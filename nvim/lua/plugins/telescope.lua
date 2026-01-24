return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
					layout_config = {
						width = 0.8,
					},
				}))
			end, { desc = "Fuzzy search in buffer" })

			-- ✨ NUEVO: Ver todos los keymaps con Space + h
			vim.keymap.set("n", "<leader>h", builtin.keymaps, { desc = "Search keymaps" })

			require("telescope").load_extension("ui-select")
		end,
	},
}
