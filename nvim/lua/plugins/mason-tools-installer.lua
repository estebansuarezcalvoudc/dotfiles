return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- Python
        "pyright",
        "ruff",
        "black",

        -- JavaScript/TypeScript
        "typescript-language-server",
        "eslint_d",
        "prettier",

        -- Lua
        "lua-language-server",
        "stylua",
      },
      auto_update = true,
      run_on_start = true,
    })
  end,
}
