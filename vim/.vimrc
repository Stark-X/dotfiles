"set nocompatible              " be iMproved, required
filetype off                  " required

" Initialize for the vim-plug
if has('win32')
    " set rtp+=$USERPROFILE/vimfiles/bundle/Vundle.vim/
    call plug#begin('$USERPROFILE/vimfiles/bundle/')
else
    " set rtp+=~/.vim/bundle/Vundle.vim/
    call plug#begin('~/.vim/bundle/')
endif

Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/L9'

" Post-update hooks to compile the YCM
" ==================== YouCompleteMe ====================
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --go-completer --js-completer --java-completer --clang-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" ==================== YouCompleteMe ====================

Plug 'Yggdroot/indentLine'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
map <f3> :NERDTreeToggle<CR>
" Ignore *.pyc
let NERDTreeIgnore = ['\.pyc$']
autocmd! User nerdtree echom 'NERDTree is now loaded.'

Plug 'scrooloose/nerdcommenter'
"markdown语法高亮
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
autocmd! User markdown-preview.vim echom 'MarkdownPreview is now loaded.'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" ==================== Snippets ====================
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<tab><tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" ==================== Snippets ====================

Plug 'terryma/vim-multiple-cursors'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'leafgarland/typescript-vim'
" Plug 'ctrlpvim/ctrlp.vim'
" Asynchronous Lint Engine
Plug 'w0rp/ale'
Plug 'posva/vim-vue'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
" Themes
Plug 'sjl/badwolf'
" Optimization for Python
Plug 'python-mode/python-mode', { 'for': 'python' }
autocmd! User python-mode echom 'Python-Mode is now loaded.'

" ==================== Auto Format ====================
Plug 'vim-scripts/groovyindent-unix'
Plug 'Chiel92/vim-autoformat'
noremap <F4> :Autoformat<CR>
let g:formatter_yapf_style = 'pep8'
" ==================== Auto Format ====================

" ==================== Code Folding ====================
Plug 'arecarn/vim-fold-cycle'
Plug 'pseewald/vim-anyfold'
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <+> <Plug>(fold-cycle-open)
nmap <-> <Plug>(fold-cycle-close)
autocmd Filetype python let b:anyfold_activate=1
set foldlevel=0
" ==================== Code Folding ====================
" ==================== Tags Generator ====================
" Use ^] to jump to definiation
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
" ==================== Tags Generator ====================
" ==================== Tag List ====================
Plug 'vim-scripts/taglist.vim', { 'on': 'TlistToggle' }
noremap <F2> :TlistToggle<CR>
" ==================== Tag List ====================

" ==================== WeChat App ====================
Plug 'chemzqm/wxapp.vim'
let g:neomake_wxml_enabled_makers = ['tidy', 'stylelint']
let g:user_emmet_settings = {
  \ 'wxss': {
  \   'extends': 'css',
  \ },
  \ 'wxml': {
  \   'extends': 'html',
  \   'aliases': {
  \     'div': 'view',
  \     'span': 'text',
  \   },
  \  'default_attributes': {
  \     'block': [{'wx:for-items': '{{list}}','wx:for-item': '{{item}}'}],
  \     'navigator': [{'url': '', 'redirect': 'false'}],
  \     'scroll-view': [{'bindscroll': ''}],
  \     'swiper': [{'autoplay': 'false', 'current': '0'}],
  \     'icon': [{'type': 'success', 'size': '23'}],
  \     'progress': [{'precent': '0'}],
  \     'button': [{'size': 'default'}],
  \     'checkbox-group': [{'bindchange': ''}],
  \     'checkbox': [{'value': '', 'checked': ''}],
  \     'form': [{'bindsubmit': ''}],
  \     'input': [{'type': 'text'}],
  \     'label': [{'for': ''}],
  \     'picker': [{'bindchange': ''}],
  \     'radio-group': [{'bindchange': ''}],
  \     'radio': [{'checked': ''}],
  \     'switch': [{'checked': ''}],
  \     'slider': [{'value': ''}],
  \     'action-sheet': [{'bindchange': ''}],
  \     'modal': [{'title': ''}],
  \     'loading': [{'bindchange': ''}],
  \     'toast': [{'duration': '1500'}],
  \     'audio': [{'src': ''}],
  \     'video': [{'src': ''}],
  \     'image': [{'src': '', 'mode': 'scaleToFill'}],
  \   }
  \ },
  \}
" ==================== WeChat App ====================

" ==================== Syntax Support  ====================
" Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'sheerun/vim-polyglot'
" ==================== Syntax Support  ====================

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

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
nmap <C-P> :Files<CR>

" All of your Plugs must be added before the following line
call plug#end()            " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
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
" let g:solarized_termcolors=256
" colorscheme solarized
"colorscheme desert
" colorscheme gruvbox 
" let g:gruvbox_contrast_dark="hard"
colorscheme badwolf
set guifont=Source_Code_Pro:h13

set hls
set nu
set tabstop=8
set shiftwidth=4
set softtabstop=8
set smarttab
set smartindent
set expandtab
"突出显示当前行
set cursorline
"开启状态栏
set laststatus=2
"显示输入的命令
set showcmd
"在状态栏显示当前光标位置
set ruler
"命令模式下按tab列出补全的命令
set wildmenu

vmap <C-c> "+y
imap jk <Esc>

autocmd FileType c,cpp setlocal cindent
autocmd FileType feature setlocal shiftwidth=2
autocmd FileType make setlocal noet
autocmd FileType groovy setlocal cindent
autocmd FileType yaml,conf,json,javascript,vue,markdown setlocal cindent sw=2

" for typescript-vim
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
autocmd FileType typescript :setlocal makeprg=tsc " find the tsconfig.json to compile

"markdown-setting: YAML
let g:vim_markdown_frontmatter=1

"YCM_Settings
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
let g:syntastic_cpp_compiler='g++' "change the compiler to 'g++' to support c++11
let g:syntastic_cpp_compiler_options='-std=c++11 -stdlib=libc++'  "set the options of g++ to support c++11
" YCM with TypeScript
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_server_python_interpreter = 'python3'

"MarkdownPreview-KeyMapping
nmap <silent> <F8> <Plug>MarkdownPreview        " for normal mode
imap <silent> <F8> <Plug>MarkdownPreview        " for insert mode
nmap <silent> <F9> <Plug>StopMarkdownPreview    " for normal mode
imap <silent> <F9> <Plug>StopMarkdownPreview    " for insert mode
if has('win32')
    let g:mkdp_path_to_chrome = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
endif
if has('macunix')
    let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
endif
let g:mkdp_auto_close = 1
let g:mkdp_auto_open = 1

"copy and paste
vmap <Leader>y "+y
vmap <Leader>p "+p
nmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader>P "+P

" default width and height
" set lines=27 columns=100

" Emmet (C-y ,)
autocmd FileType html,css,vue EmmetInstall

" let the markdown files link normal
let g:vim_markdown_conceal = 0

" vertical split resize
nmap <c-w>[ :vertical resize -5<CR>
nmap <c-w>] :vertical resize +5<CR>

" improve performance
set lazyredraw

" airline realted
" let g:airline_theme="wombat"
let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set encoding=utf-8
set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1

" makes the % command work better
packadd matchit

" ALE setting
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_linters = {
\   'javascript': ['standard'],
\   'typescript': ['tslint'],
\   'python': ['autopep8']
\}
" Fix files when they are saved.
let g:ale_fix_on_save = 1
let b:ale_fixers = ['prettier', 'eslint']


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

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Auto-paris fly mode
let g:AutoPairsFlyMode = 0

" Easy search the select content
vnoremap // y/<c-r>"<cr>

" ctrlp ignore
" let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

" Comment with one Space
let g:NERDSpaceDelims=1
" NERDCommenter for vue settings
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction
let g:vue_disable_pre_processors=1


" Vim general
set nofoldenable

" ==================== Easy Motion ====================
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap <space> <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap <space>s <Plug>(easymotion-overwin-f2)

" <space>f{char} to move to {char}
map  <space>f <Plug>(easymotion-bd-f)
nmap <space>f <Plug>(easymotion-overwin-f)

" Move to line
map <space>L <Plug>(easymotion-bd-jk)
nmap <space>L <Plug>(easymotion-overwin-line)

" Move to word
map  <space>w <Plug>(easymotion-bd-w)
nmap <space>w <Plug>(easymotion-overwin-w)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <space>j <Plug>(easymotion-j)
map <space>k <Plug>(easymotion-k)
" ==================== Easy Motion ====================


"Keep search pattern at the center of the screen."
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
