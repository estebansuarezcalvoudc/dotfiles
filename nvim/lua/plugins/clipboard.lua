return {
  "ojroques/nvim-osc52",
  lazy = false,
  priority = 1000,
  config = function()
    require("osc52").setup({
      max_length = 0,
      silent = false,
      trim = false,
    })

    -- Detectar si estamos en SSH
    local function is_ssh()
      return os.getenv("SSH_CLIENT") ~= nil 
        or os.getenv("SSH_TTY") ~= nil 
        or os.getenv("SSH_CONNECTION") ~= nil
    end

    if is_ssh() then
      vim.notify("SSH detectado - OSC52 activado", vim.log.levels.INFO)
      
      -- Copiar automáticamente al portapapeles del portátil cuando copies en Neovim
      vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("osc52_yank", { clear = true }),
        callback = function()
          if vim.v.event.operator == 'y' or vim.v.event.operator == 'd' or vim.v.event.operator == 'c' then
            require("osc52").copy(table.concat(vim.v.event.regcontents, "\n"))
          end
        end,
      })
    else
      -- En local, usar el portapapeles normal del sistema
      vim.opt.clipboard = "unnamedplus"
    end
  end,
}
