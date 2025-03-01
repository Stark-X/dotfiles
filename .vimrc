"-----------------------------------------------------------------------------------

" Configuration file for vim
" latest version had fixed this issue
" set modelines=0		" CVE-2007-2438

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
