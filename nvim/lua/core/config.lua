-- AUTOCMDS for various things
-- Correct syntax highlighting inside netrw
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype == "netrw" then
      vim.cmd([[setlocal syntax=netrw]])
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd([[startinsert]])
  end,
})

-- VIM OPTS

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Cursor config
vim.opt.guicursor = "i-ci-ve:ver25"

-- Cursorline, statusline and scrolling
vim.wo.cursorline = true
vim.wo.cursorlineopt = "both"
vim.opt.smoothscroll = true
vim.opt.showmode = false

-- Numbers config
vim.opt.number = true
vim.opt.relativenumber = true

-- Type-writer mode = ON xD
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Color columns
vim.opt.colorcolumn = "81"

-- Tab config
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Vim indenting
vim.opt.smartindent = true
vim.opt.breakindent = true

-- No text wrapping
vim.opt.wrap = false

-- Search tweaks, highlighting and included search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Highlight bracket pairs
vim.opt.showmatch = true
vim.opt.matchtime = 10

-- Terminal colors
vim.opt.termguicolors = true

-- Update time
vim.opt.updatetime = 50

-- Set nvim timeout
vim.opt.timeoutlen = 500

-- Added auto signs to the signcolumn
vim.opt.signcolumn = "auto:1-4"

-- Disable fold marks
vim.o.foldenable = false

-- NVIM Plugin set zone
-- netrw config
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_silent = 1
vim.g.netrw_fastbrowse = 0

-- Undotree & NVIM integration config:
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Max CMP height
vim.o.pumheight = 20

-- Sesssion config
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
