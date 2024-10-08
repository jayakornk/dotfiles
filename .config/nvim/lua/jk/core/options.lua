local opt = vim.opt
local o = vim.o
local g = vim.g

-- Set leader key
g.mapleader = ' '
g.maplocalleader = ' '

-------------------------------------- options ------------------------------------------
o.termguicolors = true

o.laststatus = 3
o.showmode = false

o.clipboard = 'unnamedplus'
o.cursorline = true
o.cursorlineopt = 'number'

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = ' ' }
o.ignorecase = true
o.smartcase = true
o.mouse = 'a'

o.wrap = false
o.linebreak = true

-- Numbers
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.ruler = false

-- disable nvim intro
opt.shortmess:append 'sI'

o.signcolumn = 'yes'
o.splitbelow = true
o.splitright = true
o.timeoutlen = 300
o.undofile = true

-- Minimal number of screen lines to keep above and below the cursor.
o.scrolloff = 10
o.sidescrolloff = 10

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- vim.wo.signcolumn = 'yes'

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
-- opt.whichwrap:append("<>[]hl")

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has 'win32' ~= 0
local sep = is_windows and '\\' or '/'
local delim = is_windows and ';' or ':'
vim.env.PATH = table.concat({ vim.fn.stdpath 'data', 'mason', 'bin' }, sep) .. delim .. vim.env.PATH
