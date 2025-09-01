vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true
vim.bo.softtabstop = 4

-- Format options → See [ :h 'formatoptions' ]
vim.opt.formatoptions = vim.opt.formatoptions
  - "t" -- No autoformatting based on `textwidth`
  - "a" -- No autoformatting, AGAIN.
  - "o" -- o / O do not continue comments if launched from within them.
  - "2" -- Not in gradeschool ;)
  + "r" -- But Enter in Insertmode does.
  + "n" -- Do recognize numbered lists.
  + "c" -- But I do like when comments respect textwidth :D
  + "j" -- Autoremove comments if possible.
