return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-M-y>",
          next = "<C-M-n>",
          prev = "<C-M-p>",
          dismiss = "<C-M-e>",
          accept_word = false,
          accept_line = false,
        },
      },
    })
  end,
}
