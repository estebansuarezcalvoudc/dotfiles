return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		config = function()
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
			})
		end,
	},
	vim.keymap.set("n", "<C-n>", function()
		local tree_win = nil
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.api.nvim_buf_get_option(buf, "filetype")
			if ft == "neo-tree" then
				tree_win = win
				break
			end
		end

		if tree_win then
			vim.api.nvim_win_close(tree_win, true) -- hide the tree
		else
			vim.cmd("Neotree reveal filesystem right") -- show the tree
		end
	end, { desc = "Toggle Neo-tree on the right" }),
}
