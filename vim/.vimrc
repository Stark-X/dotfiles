" Remove python3(3.7) importlib deprecated warning
" It had been fixed from "patch-8.1.201"
" https://github.com/vim/vim/issues/3117
if has('python3') && !has('patch-8.1.201')
  silent! python3 1
endif

" Initialize for the vim-plug
if has('win32')
    " set rtp+=$USERPROFILE/vimfiles/bundle/Vundle.vim/
    call plug#begin('$USERPROFILE/vimfiles/bundle/')
else
    " set rtp+=~/.vim/bundle/Vundle.vim/
    call plug#begin('~/.vim/bundle/')
endif

" ==================== coc ====================

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_global_extensions = [
  \'coc-markdownlint',
  \'@yaegassy/coc-ansible',
  \'@yaegassy/coc-nginx',
  \'@yaegassy/coc-pylsp',
  \'@yaegassy/coc-volar',
  \'@yaegassy/coc-volar-tools',
  \'coc-css',
  \'coc-docker',
  \'coc-dot-complete',
  \'coc-eslint',
  \'coc-explorer',
  \'coc-floaterm',
  \'coc-fzf-preview',
  \'coc-git',
  \'coc-groovy',
  \'coc-highlight',
  \'coc-html',
  \'coc-java',
  \'coc-json',
  \'coc-lightbulb',
  \'coc-lists',
  \'coc-markdown-preview-enhanced',
  \'coc-markdownlint',
  \'coc-markmap',
  \'coc-prettier',
  \'coc-pydocstring',
  \'coc-pyright',
  \'coc-sh',
  \'coc-snippets',
  \'coc-sql',
  \'coc-tabnine',
  \'coc-toml',
  \'coc-tsserver',
  \'coc-webview',
  \'coc-xml',
  \'coc-yaml',
  \'coc-yank'
  \]

nnoremap <silent> <space>c :<C-u>CocFzfList commands<CR>
nnoremap <silent> <space>a :<C-u>CocFzfList actions<CR>
vnoremap <silent> <space>a :<C-u>CocAction<CR>
nnoremap <silent> <space>g :<C-u>CocList --normal gstatus<CR>

"<leader>hp to open a preview widown, provided by vim-gitgutter
" show chunkinfo like IDEA
nmap d <Plug>(coc-git-chunkinfo)

" for jump to next placeholder
let g:coc_snippet_next = '<c-b>'
" for jump to previous placeholder
let g:coc_snippet_prev = '<c-z>'
" for convert visual selected code to snippet
xmap <leader>x <Plug>(coc-convert-snippet)
" for trigger snippet expand.
imap <tab> <Plug>(coc-snippets-expand)

" GoTo code navigation.
nmap <silent> <leader>jd <Plug>(coc-definition)
nmap <silent> <leader>jy <Plug>(coc-type-definition)
nmap <silent> <leader>ji <Plug>(coc-implementation)
nmap <silent> <leader>jr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" grep word under cursor
command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList grep '.<q-args>

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <Leader>cf :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>
nnoremap <silent> <Leader>w  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>

nnoremap <silent> <space>y  :<C-u>CocFzfList yank<cr>
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

autocmd FileType markdown let b:coc_suggest_disable = 1
" ==================== coc ====================

Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/L9'

Plug 'Yggdroot/indentLine'
let g:indentLine_char='⎸'

Plug 'scrooloose/nerdcommenter'

" ==================== NERDTree ====================
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
map <F3> :NERDTreeToggle<CR>
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
" ==================== NERDTree ====================

" markdown syntax highlight
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_toc_autofit = 1
" Show the link url explicitly
let g:vim_markdown_conceal = 0
" Show the code block symbol explicitly
let g:vim_markdown_conceal_code_blocks = 0
"markdown-setting: YAML
let g:vim_markdown_frontmatter=1
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
autocmd! User markdown-preview.vim echom 'MarkdownPreview is now loaded.'
autocmd! User vim-markdown echom 'vim-markdown is now loaded.'

":GenTocGFM
":GenTocGitLab
":GenTocMarked
":UpdateToc
":RemoveToc
Plug 'mzlogin/vim-markdown-toc'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" ==================== Snippets ====================
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" let g:UltiSnipsExpandTrigger="<tab><tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" ==================== Snippets ====================

Plug 'terryma/vim-multiple-cursors'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'leafgarland/typescript-vim'
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'posva/vim-vue'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
" Themes
Plug 'patstockwell/vim-monokai-tasty'

let py_line_max_length = 120

" Optimization for Python
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop'}
autocmd! User python-mode echom 'Python-Mode is now loaded.'
autocmd! User python-mode let g:pymode_python = 'python3'
let g:pymode_doc_bind = '<leader>d'
let g:pymode_options_max_line_length = py_line_max_length

" ==================== groovy ====================
Plug 'vim-scripts/groovyindent-unix'
Plug 'vim-scripts/groovy.vim'
autocmd Filetype groovy setlocal sw=2
" ==================== groovy ====================

" ==================== Auto Format ====================
Plug 'Chiel92/vim-autoformat'
noremap <F4> :Autoformat<CR>
" let g:formatter_yapf_style = 'pep8'
" let g:formatters_python = ['autopep8']
" ==================== Auto Format ====================

" ==================== Code Folding ====================
Plug 'arecarn/vim-fold-cycle'
Plug 'pseewald/vim-anyfold'
let g:fold_cycle_default_mapping = 0 "disable default mappings
nmap <+> <Plug>(fold-cycle-open)
nmap <-> <Plug>(fold-cycle-close)
set foldlevel=5

" activate anyfold by default
augroup anyfold
    autocmd!
    autocmd Filetype python,java AnyFoldActivate
augroup END

" disable anyfold for large files
let g:LargeFile = 1000000 " file is large if size greater than 1MB
autocmd BufReadPre,BufRead * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
function LargeFile()
    augroup anyfold
        " remove AnyFoldActivate
        autocmd!
        autocmd Filetype python setlocal foldmethod=indent " fall back to indent folding
    augroup END
endfunction
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

" Execute linux cmd in vim
" :SudoWrite, :SudoEdit, :Mkdirr etc.
Plug 'tpope/vim-eunuch'
" ']' and '[' mappings
" '[e', ']e' exchange lines, '[<space>', ']<space>' add blank lines, etc.
" '[l', ']l' jump between warnings generated by lint tools
Plug 'tpope/vim-unimpaired'
" Browsing the files
Plug 'justinmk/vim-dirvish'
Plug 'dyng/ctrlsf.vim'
" 使用 ctrlsf.vim 插件在工程内全局查找光标所在关键字，设置快捷键。快捷键速记法：search in project
nnoremap <Leader>sp :CtrlSF<CR>
let g:ctrlsf_auto_focus = {"at": "start"}

" ==================== vim-expand-region ====================
" + expand_region_expand
" _ expand_region_shrink
Plug 'terryma/vim-expand-region'
" ==================== vim-expand-region ====================

" git diff display on the left side
Plug 'airblade/vim-gitgutter'

" toggle quickfix list with <learder>q and toggle location list with <leader>l
Plug 'Valloric/ListToggle'

" select and press gr
Plug 'vim-scripts/ReplaceWithRegister'


" Automatically clears search highlight when cursor is moved
" Improved star-search (visual-mode, highlighting without moving)
Plug 'junegunn/vim-slash'

" ==================== ansible-vim ====================
" Syntax plugin for Ansible
Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }
let g:ansible_unindent_after_newline = 1
" ==================== ansible-vim ====================

Plug 'godlygeek/tabular'

" ==================== Asynchronous Lint Engine ====================
Plug 'dense-analysis/ale'
nmap <silent> ]a :ALENextWrap<cr>
nmap <silent> [a :ALEPreviousWrap<cr>

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
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'python': ['pylint'],
\   'yaml': ['yamllint', 'prettier'],
\   'vue': ['eslint', 'vls']
\}
let g:syntastic_python_pylint_post_args="--max-line-length=".py_line_max_length


let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']

" ==================== Asynchronous Lint Engine ====================

Plug 'tommcdo/vim-exchange'
Plug 'machakann/vim-highlightedyank'
Plug 'vim-scripts/argtextobj.vim'

" calcuate programming time
Plug 'wakatime/vim-wakatime'

" ==================== Float Terminal ====================
Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'
" let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_new = '<leader>ft'
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
" colorscheme solarized8

let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty
let g:airline_theme='monokai_tasty'

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

" airline realted
" let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
set encoding=utf-8
if has('win32')
    set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
endif

" makes the % command work better
packadd matchit

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

" Comment with one Space
let g:NERDSpaceDelims=1
" ==================== Vue ====================
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

" ==================== Vue ====================


" Disable auto fold
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


" Disable cursor blinking 
set gcr=a:block-blinkon0
" Display the options for a command
set wildmenu

set fencs=ucs-bom,utf-8,gbk,gb2312,default,latin

" autocmd Filetype python map <leader>tt :!pytest -v<CR>
" autocmd Filetype python map <leader>ts :!pytest -sv<CR>
" autocmd Filetype python map <leader>tp :!pytest -v --pdb<CR>

" ===== kite =====
let g:kite_tab_complete=1
set completeopt+=popup
set completeopt+=menuone
set completeopt+=noselect
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

