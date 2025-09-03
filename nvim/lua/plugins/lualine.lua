return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  config = function()
    local lualine = require("lualine")

    -- Colores
    local colors = {
      bg          = '#202328',
      fg          = '#bbc2cf',
      violet      = '#a9a1e1',
      radioactive = '#FAE500',
      yellow      = '#ECBE7B',
      cyan        = '#008080',
      pink        = '#FF00FF',
      darkblue    = '#0037AA',
      turquoise   = '#00CCCC',
      green       = '#98be65',
      lime        = '#00CC00',
      orange      = '#FF8800',
      sorange     = '#FF6600',
      magenta     = '#c678dd',
      blue        = '#51afef',
      red         = '#FF0000',
      ultraviolet = '#CC0099',

      catppuccin_rosewater = '#f5e0dc',
      catppuccin_flamingo = '#f2cdcd',
      catppuccin_pink = '#f5c2e7',
      catppuccin_mauve = '#cba6f7',
      catppuccin_red = '#f38ba8',
      catppuccin_maroon = '#eba0ac',
      catppuccin_peach = '#fab387',
      catppuccin_yellow = '#f9e2af',
      catppuccin_green = '#a6e3a1',
      catppuccin_teal = '#94e2d5',
      catppuccin_sky = '#89dceb',
      catppuccin_sapphire = '#74c7ec',
      catppuccin_blue = '#89b4fa',
      catppuccin_lavender = '#b4befe',
      catppuccin_base = '#1e1e2e',
      catppuccin_text = '#cdd6f4',
      catppuccin_subtext0 = '#a6adc8',
      catppuccin_mantle = '#181825',
      catppuccin_surface0 = '#313244',
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
    }

    local function wordcount()
      return tostring(vim.fn.wordcount().words) .. " words"
    end

    local function readingtime()
      return tostring(math.ceil(vim.fn.wordcount().words / 200.0)) .. " min"
    end

    local function is_markdown()
      return vim.bo.filetype == "markdown" or vim.bo.filetype == "asciidoc"
    end

    -- Configuración base
    local config = {
      options = {
        component_separators = "",
        section_separators = "",
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "trouble" },
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {},
      extensions = { "lazy" },
    }

    -- Helpers
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    -- --- COMPONENTES ---

    -- Icono nvim
    ins_left({
      function() return "" end,
      color = { fg = colors.catppuccin_green },
      padding = { left = 1, right = 1 },
    })

    -- Modo actual
    ins_left({
      function()
        local mode = vim.fn.mode()
        return "   [" .. string.upper(mode) .. "]"
      end,
      color = function()
        local mode_color = {
          n = colors.catppuccin_mauve,
          i = colors.catppuccin_sky,
          v = colors.catppuccin_green,
          V = colors.catppuccin_peach,
          [""] = colors.catppuccin_sapphire,
          R = colors.catppuccin_blue,
          c = colors.catppuccin_red,
          t = colors.catppuccin_red,
        }
        return { fg = colors.catppuccin_base, bg = mode_color[vim.fn.mode()] or colors.catppuccin_text }
      end,
      separator = { left = " ", right = "" },
    })

    -- Nombre del archivo
    ins_left({
      "filename",
      cond = conditions.buffer_not_empty,
      color = { fg = colors.catppuccin_green, gui = "bold" },
      path = 0,
      symbols = { modified = "[+]", readonly = "[]", unnamed = "[No Name]", newfile = "[New]" },
    })

    -- Rama git
    ins_left({
      "branch",
      icon = "",
      color = { fg = colors.catppuccin_peach, gui = "bold" },
      cond = conditions.hide_in_width,
    })

    -- Noice status (solo si existe)
    if package.loaded["noice"] then
      ins_left({
        function() return "󰌓 " .. require("noice").api.status.command.get() end,
        cond = function() return require("noice").api.status.command.has() end,
        color = { fg = colors.catppuccin_pink, gui = "bold" },
      })

      ins_left({
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
        color = { fg = colors.catppuccin_pink, gui = "bold" },
      })
    end

    -- Lazy updates
    if package.loaded["lazy"] then
      ins_left({
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
      })
    end

    -- Separador
    ins_left({ function() return "%=" end })

    -- Diagnósticos
    ins_left({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      diagnostics_color = {
        error = { fg = colors.catppuccin_red },
        warn = { fg = colors.catppuccin_yellow },
        info = { fg = colors.catppuccin_sapphire },
        hint = { fg = colors.catppuccin_lavender },
      },
    })

    -- Git diff
    ins_left({
      "diff",
      symbols = { added = " ", modified = " ", removed = " " },
      diff_color = {
        added = { fg = colors.lime },
        modified = { fg = colors.catppuccin_peach },
        removed = { fg = colors.catppuccin_red },
      },
      cond = conditions.hide_in_width,
    })

    -- Wordcount / Readingtime (solo markdown)
    ins_right({ wordcount, cond = is_markdown })
    ins_right({ readingtime, cond = is_markdown })

    -- Tamaño del archivo
    ins_right({
      "filesize",
      cond = conditions.buffer_not_empty,
      color = { fg = colors.catppuccin_mauve },
    })

    -- Progreso %
    ins_right({
      "progress",
      color = { fg = colors.catppuccin_mauve, gui = "bold" },
    })

    -- Ubicación
    ins_right({
      "location",
      color = { fg = colors.catppuccin_green, gui = "bold" },
    })

    -- LSP cliente
    ins_right({
      function()
        local msg = "None"
        local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 }) or vim.lsp.get_active_clients()
        if next(clients) == nil then return msg end
        return clients[1].name
      end,
      icon = "",
      color = { fg = colors.catppuccin_sapphire, gui = "bold" },
      cond = conditions.hide_in_width,
    })

    -- Filetype
    ins_right({
      "filetype",
      colored = true,
      icon_only = false,
      icon = { align = "left" },
      color = { fg = colors.catppuccin_blue, gui = "bold" },
      cond = conditions.hide_in_width,
    })

    -- Inicializar
    lualine.setup(config)
  end,
}
