return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    count_chars = {
      [1] = "",
      [2] = "₂",
      [3] = "₃",
      [4] = "₄",
      [5] = "₅",
      [6] = "₆",
      [7] = "₇",
      [8] = "₈",
      [9] = "₉",
      ["+"] = "󰎿",
    },
    numhl = true,
    attach_to_untracked = true,
    trouble = false,
    signs = {
      add = { text = "+" },
      change = { text = "󰇙" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "" },
    },
    signs_staged = {
      add = { text = "+" },
      change = { text = "󰇙" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "" },
    },
  },

  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
}
