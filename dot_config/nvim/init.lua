-- advise from NvimTree disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")

vim.cmd([[let &packpath = &runtimepath]])
vim.cmd([[source ~/.vimrc]])
-- use cyberdream in the packer section
-- vim.cmd([[colorscheme vim-monokai-tasty]])

vim.o.lazyredraw = true
vim.g.python3_host_prog = "$HOME/.pyenv/versions/neovim/bin/python"

require("plugins")
require("neovide")
