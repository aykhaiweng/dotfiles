-- uhhhh
vim.opt.guicursor = ""

-- clipboard
-- vim.opt.clipboard = "unnamed,unnamedplus"

-- set line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- tabline
vim.opt.showtabline = 2
-- Focus on the split window when opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- show whitespaces, tabs and spaces
vim.opt.listchars = "tab:--,trail:·,nbsp:~,extends:>,precedes:<,eol:¬"
vim.opt.list = true

-- indents - use 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- smart indents
vim.opt.smartindent = true

-- stops vim from wrapping lines
vim.opt.wrap = false

-- swaps and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir/"
vim.opt.undofile = true

-- search hightlighting
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- terminal colors
vim.opt.termguicolors = true

-- scrolloff
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- updatetime
vim.opt.updatetime = 50

-- Python implementation
vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/neovim3/bin/python3"
