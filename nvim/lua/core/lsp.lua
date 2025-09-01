-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "cssls",       -- CSS
    "jdtls",       -- Java
    "gopls",       -- Go
    "clangd",      -- C, C++
    "csharp_ls",   -- C#
    "ts_ls",    -- JavaScript, TypeScript
    "rust_analyzer", -- Rust
    "phpactor",    -- PHP
    "lua_ls",      -- Lua
  }
})

local lspconfig = require("lspconfig")

local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
  end
  bufmap('n', 'gd', vim.lsp.buf.definition)
  bufmap('n', 'K', vim.lsp.buf.hover)
  bufmap('n', '<leader>rn', vim.lsp.buf.rename)
  bufmap('n', '<leader>ca', vim.lsp.buf.code_action)
  bufmap('n', '[d', vim.diagnostic.goto_prev)
  bufmap('n', ']d', vim.diagnostic.goto_next)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configuración para cada lenguaje

lspconfig.cssls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.jdtls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    }
  }
}

lspconfig.clangd.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
}

lspconfig.csharp_ls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.ts_ls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    }
  }
}

lspconfig.phpactor.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.lua_ls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false }
    }
  }
}

-- nvim-cmp + luasnip (autocompletado y snippets)
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Opcional: Diagnósticos más visibles
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
})
