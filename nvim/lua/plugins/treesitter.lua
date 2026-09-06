return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Instalar parsers (asíncrono; no-op si ya están instalados)
    require("nvim-treesitter").install({
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "elixir",
      "heex",
      "javascript",
      "typescript",
      "tsx",
      "python",
      "html",
      "markdown",
      "markdown_inline",
    })

    -- Habilitar highlight + indent por filetype (equivalente a los viejos
    -- highlight = { enable = true } / indent = { enable = true })
    local filetypes = {
      "c", "lua", "vim", "help", "query",
      "elixir", "heex", "javascript", "typescript", "typescriptreact",
      "python", "html", "markdown",
    }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function(ev)
        local ok = pcall(vim.treesitter.start)
        if ok then
          -- indent experimental (como el viejo indent = { enable = true })
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
