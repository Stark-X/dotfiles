" advise from NvimTree disable netrw at the very start of your init.lua (strongly advised)
let g:loaded = 1
let g:loaded_netrwPlugin = 1

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
let g:python3_host_prog="$HOME/.pyenv/versions/neovim/bin/python"

colorscheme vim-monokai-tasty

" neovim config in lua file
lua require("index")
