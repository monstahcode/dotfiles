return {
  {
    "mhartington/formatter.nvim",
    keys = {
      { "<leader>ff", "<cmd>Format<CR>", desc = "Dar formato al archivo actual" },
    },
    config = function()
      require("formatter").setup({
        logging = false,
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua,
          },
          java = { vim.lsp.buf.format({ async = true })
          },
        },
      })
    end,
  },
    {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason-tool-installer").setup {
        ensure_installed = {
          "stylua",
          "prettierd",
          "lua-language-server",
          "html-lsp",
          -- Java
          "java-debug-adapter",
          "jdtls",
          -- PHP
          "php-cs-fixer",
          "phpactor",
          "phpcbf",
        },
        auto_update = true,
        debounce_hours = 2,
      }
    end
  }
}
