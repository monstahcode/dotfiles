return {
  "rcarriga/nvim-notify",
  event = "BufRead",
  opts = {
    stages = "static",
    timeout = 1500,
    render = "compact",
    max_height = function()
      return math.floor(vim.o.lines * 0.40)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.70)
    end,
  },
  config = function()
    require("notify").setup({
      background_colour = "#000000",
    })
    vim.notify = require("notify")
  end,
}
