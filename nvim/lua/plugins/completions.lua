return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = true,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Format items with Tailwind colors
      local format_kinds = cmp.config.window.bordered().winhighlight
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = {
          autocomplete = { 
            require('cmp.types').cmp.TriggerEvent.TextChanged,
            require('cmp.types').cmp.TriggerEvent.InsertEnter,
          },
        },
        formatting = {
          format = require("tailwindcss-colorizer-cmp").formatter,
        },
        mapping = cmp.mapping.preset.insert({
          -- Scroll documentation
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Trigger completion manually
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Abort completion
          ["<C-e>"] = cmp.mapping.abort(),

          -- Move in completion menu
          ["<A-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<A-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

          -- Tab behavior: complete -> jump snippet -> tab out of brackets -> normal tab
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              -- Tab out of brackets/quotes when cursor is before them
              local col = vim.fn.col(".")
              local line = vim.fn.getline(".")
              local next_char = line:sub(col, col)
              local tabout_chars = { [")"] = true, ["}"] = true, ["]"] = true, [";"] = true, ['"'] = true, ["'"] = true }
              
              if tabout_chars[next_char] then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
              else
                fallback()
              end
            end
          end, { "i", "s" }),

          -- Jump backwards in snippet
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Enter: only confirm if explicitly selected, otherwise new line
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
