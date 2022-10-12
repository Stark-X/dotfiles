" advise from NvimTree disable netrw at the very start of your init.lua (strongly advised)
let g:loaded = 1
let g:loaded_netrwPlugin = 1

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
let g:python3_host_prog="$HOME/.pyenv/versions/neovim/bin/python"

" Figure out the system Python for Neovim.
" if exists("$VIRTUAL_ENV")
    " let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
" else
    " let g:python3_host_prog=substitute("$HOME/.pyenv/versions/neovim/bin/python", "\n", '', 'g')
" endif

" neovim config in lua file
lua require("index")

