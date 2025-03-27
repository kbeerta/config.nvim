local g = vim.g
local opt = vim.opt

opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.splitright = true
opt.termguicolors = true

opt.laststatus = 3
opt.showmode = false

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.completeopt = "menuone,noselect,popup,fuzzy"

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.cursorlineopt = "number"

opt.signcolumn = "no"

opt.scrolloff = 10

opt.hlsearch = false

opt.undofile = true
opt.swapfile = false

opt.updatetime = 250

vim.diagnostic.config({ virtual_text = true })
