return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview: open" },
    { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diffview: close" },
  },
  config = function()
    require("diffview").setup()
  end,
}
