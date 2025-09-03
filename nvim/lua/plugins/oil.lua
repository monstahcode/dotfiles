return {
  "stevearc/oil.nvim",
  lazy = true,
  cmd = { "Oil" },
  opts = {
    columns = { "icon" },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["-"] = "actions.open",      -- Abre el explorador al presionar "-"
      ["_"] = "actions.parent",    -- Va al directorio padre al presionar "_"
      ["q"] = "actions.close",
      ["<C-r>"] = "actions.refresh",
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
