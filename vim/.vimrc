" Remove python3(3.7) importlib deprecated warning
" It had been fixed from "patch-8.1.201"
" https://github.com/vim/vim/issues/3117
if has('python3') && !has('patch-8.1.201')
  silent! python3 1
endif

" Initialize for the vim-plug
if has('win32')
    call plug#begin('$USERPROFILE/vimfiles/bundle/')
else
    call plug#begin('~/.vim/bundle/')
endif

" Optimization for Python
" Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop'}
" autocmd! User python-mode echom 'Python-Mode is now loaded.'
" autocmd! User python-mode let g:pymode_python = 'python3'
" let g:pymode_doc_bind = '<leader>d'
" let g:pymode_options_max_line_length = py_line_max_length


" ==================== ACK ====================
" Take place the vimgrep
function! Install_ag(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        if has('macunix')
            !brew install the_silver_searcher
        else
            echo 'Please access https://github.com/ggreer/the_silver_searcher for the installation'
        endif
    endif
endfunction
" Use ag(the_silver_searcher) as the search engine
Plug 'mileszs/ack.vim', { 'do': function('Install_ag') }
let g:ackprg = 'ag --vimgrep --hidden'
" ==================== ACK ====================

" ==================== FZF ====================
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" :CocFzfList xxx
Plug 'antoinemadec/coc-fzf'
let g:coc_fzf_preview = 'right:50%'
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
nmap <C-P> :Files<CR>
nmap <C-H> :History<CR>
nmap <C-T> :Buffers<CR>
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-t': 'tabnew',
  \ 'ctrl-v': 'vsplit'}
" ==================== FZF ====================

Plug 'dyng/ctrlsf.vim'
" 使用 ctrlsf.vim 插件在工程内全局查找光标所在关键字，设置快捷键。快捷键速记法：search in project
nnoremap <Leader>sp :CtrlSF<CR>
let g:ctrlsf_auto_focus = {"at": "start"}

" ==================== Asynchronous Lint Engine ====================
Plug 'dense-analysis/ale'
nmap <silent> ]a :ALENextWrap<cr>
nmap <silent> [a :ALEPreviousWrap<cr>

" use coc.nvim lsp instead
let g:ale_disable_lsp = 1
" Fix files when they are saved.
let g:ale_fix_on_save = 0
nnoremap <silent> <leader>f :ALEFix<cr>
" :help ale-fix (<C-]> to jump tag, <C-t> to come back)
" NOTE: check the help document for some tools installation
" :ALEFixSuggest to get the suggest the supported fixers
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'javascript': ['eslint'],
\   'typescript': ['prettier'],
\   'python': ['isort', 'black', 'autopep8'],
\   'yaml': ['trim_whitespace'],
\   'vue': ['eslint']
\}
" Run both javascript and vue linters for vue files.
let g:ale_linter_aliases = {'vue': ['vue', 'javascript']}

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_linters = {
\   'lua': ['stylua'],
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'python': ['pylint'],
\   'yaml': ['yamllint', 'prettier'],
\   'vue': ['eslint', 'vls']
\}
let py_line_max_length = 120
let g:syntastic_python_pylint_post_args="--max-line-length=".py_line_max_length


let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']

" ==================== Asynchronous Lint Engine ====================

" ==================== Float Terminal ====================
Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F10>'

autocmd Filetype python map <leader>tt :FloatermNew pytest<CR>
autocmd Filetype python map <leader>ts :FloatermNew pytest -sv<CR>
autocmd Filetype python map <leader>tp :FloatermNew pytest -v --pdb<CR>

Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asyncrun.extra'
Plug 'skywind3000/asynctasks.vim'
noremap <silent><f5> :AsyncTask file-run<cr>
let g:asyncrun_open = 6
let g:asynctasks_term_pos = 'floaterm_reuse'
" ==================== Float Terminal ====================

let g:go_doc_popup_window = 1
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
autocmd FileType go setlocal tabstop=4

" distraction-free mode (:Goyo , :Goyo! )
Plug 'junegunn/goyo.vim'
let g:goyo_width = "50%"

" All of your Plugs must be added before the following line
call plug#end()            " required

"-----------------------------------------------------------------------------------

" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

" theme
set background=dark
colorscheme vim-monokai-tasty

if has('gui_running')
    " set guifont=Source_Code_Pro:h14
    set guifont=MesloLGS-NF-Regular:h13
endif

set hls
set nu
set tabstop=8
set shiftwidth=4
set softtabstop=8
set smarttab
set smartindent
set expandtab
" Highlight the line and th column
set cursorline
set cursorcolumn
" Enable the status line
set laststatus=2
set showcmd
" Display the line numbe in the status line
set ruler

vmap <C-c> "+y

autocmd FileType c,cpp setlocal cindent
autocmd FileType feature setlocal shiftwidth=2
autocmd FileType make setlocal noet
autocmd FileType groovy setlocal cindent
autocmd FileType yaml,conf,json,typescript,javascript,vue,markdown setlocal cindent sw=2
autocmd FileType scss setlocal cindent sw=2

" for typescript-vim
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
autocmd FileType typescript :setlocal makeprg=tsc " find the tsconfig.json to compile

" ==================== MarkdownPreview ====================
if has('win32')
    let g:mkdp_path_to_chrome = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
endif
if has('macunix')
    let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
endif
let g:mkdp_auto_close = 1
let g:mkdp_auto_open = 1
" ==================== MarkdownPreview ====================

if has("gui_macvim")
    " Only work on MacVim, the iTerm2 will use ^[
    set macmeta
endif

"copy and paste
vmap <Leader>y "+y
vmap <Leader>p "+p
nmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader>P "+P

" Emmet (C-y ,)
autocmd FileType html,css,vue EmmetInstall

" vertical split resize
nmap <c-w>[ :vertical resize -5<CR>
nmap <c-w>] :vertical resize +5<CR>

" improve performance
set lazyredraw

set encoding=utf-8
if has('win32')
    set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
endif

if has('win32')
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set encoding=utf-8
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
    set fileencoding=utf-8 " 新建文件使用的编码

    " 解决菜单乱码
    set langmenu=zh_CN
    let $LANG = 'zh_CN.UTF-8'
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    " Disable the alt/meta (<M-*>) mapping on the Windows menu.
    set winaltkeys=no
endif

" Easy search the select content
vnoremap // y/<c-r>"<cr>

" ==================== Vue ====================
" NERDCommenter for vue settings
" let g:ft = ''
" function! NERDCommenter_before()
  " if &ft == 'vue'
    " let g:ft = 'vue'
    " let stack = synstack(line('.'), col('.'))
    " if len(stack) > 0
      " let syn = synIDattr((stack)[0], 'name')
      " if len(syn) > 0
        " exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      " endif
    " endif
  " endif
" endfunction
" function! NERDCommenter_after()
  " if g:ft == 'vue'
    " setf vue
    " let g:ft = ''
  " endif
" endfunction
" let g:vue_disable_pre_processors=1

" ==================== Vue ====================


" Disable auto fold
set nofoldenable


"Keep search pattern at the center of the screen."
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz


" Disable cursor blinking
set gcr=a:block-blinkon0
" Display the options for a command
set wildmenu

set fencs=ucs-bom,utf-8,gbk,gb2312,default,latin

" autocmd Filetype python map <leader>tt :!pytest -v<CR>
" autocmd Filetype python map <leader>ts :!pytest -sv<CR>
" autocmd Filetype python map <leader>tp :!pytest -v --pdb<CR>

" ===== kite =====
" let g:kite_tab_complete=1
" set completeopt+=preview
" set completeopt+=menuone
" set completeopt+=noselect
" ===== kite =====

" ===== Term GUI enable true Color =====
if has("termguicolors")
    " fix bug for vim
    " set Vim-specific sequences for RGB colors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    " enable true color
    set termguicolors
endif
" ===== Term GUI enable true Color =====

let $EXTRA_VIMRC = '~/.vim/vimrc_extra'
if filereadable($EXTRA_VIMRC)
    source $EXTRA_VIMRC
endif
