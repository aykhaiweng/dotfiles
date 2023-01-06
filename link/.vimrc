set encoding=utf-8
set nocompatible              " required
filetype off                  " required
let g:python3_host_prog=$HOME."/.pyenv/versions/neovim3/bin/python3"
let mapleader=","

call plug#begin('~/.vim/plugged')
set rtp+=~/.vim/my-colors

" ==========================================================
"  gruvbox Theme
" ==========================================================
Plug 'morhetz/gruvbox'

" ==========================================================
"  vim-tmux-navigator Plugin
" ==========================================================
Plug 'christoomey/vim-tmux-navigator'
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_disable_when_zoomed = 1
nnoremap <silent> <C-H> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-J> :TmuxNavigateDown<cr>
nnoremap <silent> <C-K> :TmuxNavigateUp<cr>
nnoremap <silent> <C-L> :TmuxNavigateRight<cr>

" ==========================================================
"  Ale Plugin
" ==========================================================
Plug 'dense-analysis/ale'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'
let g:ale_set_highlights = 1
let g:ale_lint_delay = 1000
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" ==========================================================
"  indentLine Plugin
" ==========================================================
if has('nvim')
    Plug 'lukas-reineke/indent-blankline.nvim'
else
    Plug 'Yggdroot/indentLine'
    let g:indentLine_showFirstIndentLevel = 0
    let g:indentLine_char_list = ['|']
endif

" ==========================================================
"  vim-multiple-cursors Plugin
" ==========================================================
Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=1

" ==========================================================
"  vim-easymotion Plugin
" ==========================================================
Plug 'easymotion/vim-easymotion'

" ==========================================================
"  vim-surround Plugin
" ==========================================================
Plug 'tpope/vim-surround'

" ==========================================================
"  neosnippet Plugin
" ==========================================================
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
let g:neosnippet#snippets_directory='~/.vim/neosnippets/'
imap <C-e> <Plug>(neosnippet_expand_or_jump)
smap <C-e> <Plug>(neosnippet_expand_or_jump)
xmap <C-e> <Plug>(neosnippet_expand_target)

" ==========================================================
"  Tagbar Plugin
" ==========================================================
Plug 'preservim/tagbar'
nmap <C-S-b> :TagbarToggle<CR>

" ==========================================================
"  fzf Plugin
" ==========================================================
Plug 'junegunn/fzf.vim' ", { 'on': ['FZF', 'Buffers', 'Marks'] }
set rtp+=~/.fzf
nnoremap <C-P> :Files<CR>
nnoremap <C-F> :Ag<CR>

" ==========================================================
"  Deoplete Plugin
" ==========================================================
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
inoremap <expr> <C-Space> deoplete#manual_complete()

" ==========================================================
"  fern Plugin
" ==========================================================
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'yuki-yano/fern-preview.vim'
" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1
let g:fern#default_hidden = 1
let g:fern#renderer = "nerdfont"
let g:fern#renderer#nerdfont#leading = "    "
let g:fern#renderer#default#leaf = "|   "
nnoremap <C-B> :Fern . -drawer -reveal=% -toggle -width=40<CR><C-w>=
function! FernInit() abort
    nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
    nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
    nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
    nmap <buffer> n <Plug>(fern-action-new-path)
    nmap <buffer> d <Plug>(fern-action-remove)
    nmap <buffer> m <Plug>(fern-action-move)
    nmap <buffer> M <Plug>(fern-action-rename)
    nmap <buffer> r <Plug>(fern-action-reload)
    nmap <buffer> b <Plug>(fern-action-open:split)
    nmap <buffer> v <Plug>(fern-action-open:vsplit)
    nmap <silent> <buffer> p <Plug>(fern-action-preview:toggle)
    nmap <buffer><nowait> < <Plug>(fern-action-leave)
    nmap <buffer><nowait> > <Plug>(fern-action-enter)
    nmap <buffer><silent> <C-H> :TmuxNavigateLeft<cr>
    nmap <buffer><silent> <C-J> :TmuxNavigateDown<cr>
    nmap <buffer><silent> <C-K> :TmuxNavigateUp<cr>
    nmap <buffer><silent> <C-L> :TmuxNavigateRight<cr>
    nmap <silent><buffer> p <Plug>(fern-action-preview:toggle)
endfunction
augroup FernGroup
    autocmd!
    autocmd FileType fern call glyph_palette#apply()
    autocmd FileType fern call FernInit()
augroup END

" ==========================================================
"  vim-fugitive Plugin
" ==========================================================
Plug 'tpope/vim-fugitive'

" ==========================================================
"  vim-gitgutter Plugin
" ==========================================================
if has('nvim')
    Plug 'lewis6991/gitsigns.nvim'
else
    Plug 'airblade/vim-gitgutter'
endif

" ==========================================================
"  Python Plugins
"  - deoplete-jedi
" ==========================================================
Plug 'deoplete-plugins/deoplete-jedi'

" ==========================================================
"  Lightline
" ==========================================================
let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_max_signs=1000
" git wrapper for vim
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
let g:lightline = {
\   'separator': {'left': '', 'right': ''},
\   'subseparator': {'left': '', 'right': ''},
\   'tabline': {
\       'left': [['tabs']],
\       'right': [['buffers']]
\   },
\   'active': {
\       'left': [
\           [ 'mode', 'paste', ],
\           [ 'gitbranch', 'readonly', 'filepath'],
\           [ 'modified' ],
\           [ 'tagbar' ],
\       ],
\       'right': [
\           [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
\           [ 'percent', 'lineinfo' ],
\           [ 'filetype', ]
\       ]
\   },
\   'inactive': {
\       'left': [
\           [ 'filepath', 'modified' ]
\       ],
\       'right': [['']]
\   },
\   'component': {
\       'lineinfo': '%3l:%-2v',
\       'tagbar': '%{tagbar#currenttag("[%s]", "", "f")}',
\   },
\   'component_function': {
\       'linter_checking': 'lightline#ale#checking',
\       'linter_warnings': 'lightline#ale#warnings',
\       'linter_errors': 'lightline#ale#errors',
\       'linter_ok': 'lightline#ale#ok',
\       'gitbranch': 'FugitiveHead',
\       'filepath': 'LightlineFilepath',
\   }
\}

command! LightlineReload call LightlineReload()
function! LightlineReload()
    silent! call lightline#init()
    silent! call lightline#colorscheme()
    silent! call lightline#update()
endfunction

function! LightlineFilepath()
    let filename = expand('%f:h') !=# '' ? expand('%f:h') : '-'
    return filename
endfunction

let g:lightline.component_type = {
  \  'linter_checking': 'left',
  \  'linter_warnings': 'warning',
  \  'linter_errors': 'error',
  \  'linter_ok': 'left',
  \ }

au! BufEnter *
    \ :LightlineReload

" ==========================================================
"  vim-polyglot Plugin
" ==========================================================
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['vue', 'json']

" ==========================================================
"  Plug End
" ==========================================================
call plug#end()

" ==========================================================
"  Buffer and Toggle List
" ==========================================================
function! GetBufferList()
    redir =>buflist
    silent! ls!
    redir END
    return buflist
endfunction

function! ToggleList(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            exec(a:pfx.'close')
            return
        endif
    endfor
    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        echo "Location List is Empty."
        return
    endif
    let winnr = winnr()
    exec(a:pfx.'open')
    if winnr() != winnr
        wincmd p
    endif
endfunction

" ==========================================================
"  Keybinds
" ==========================================================
nnoremap <space> za
nnoremap tj  :tabfirst<CR>
nnoremap tl  :tabnext<CR>
nnoremap th  :tabprev<CR>
nnoremap tk  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnew<CR>
nnoremap tm  :tabm<Space>
nnoremap tx  :tabclose<CR>
vnoremap <silent> <F5> :sort i<CR>
nnoremap <silent> <F5> :so $MYVIMRC<CR>:LightlineReload<CR>
nnoremap <F8> :set tabstop=4 shiftwidth=4 expandtab<CR>:retab!<CR>
nnoremap <Leader>lx :lclose<CR>
nnoremap <silent> <leader>ll :call ToggleList("Location List", 'l')<CR>
nnoremap <silent> <leader>ee :call ToggleList("Quickfix List", 'c')<CR>

" ==========================================================
"  Theme
" ==========================================================
syntax on
set termguicolors
set background=dark
set t_Co=256
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
let g:gruvbox_italicize_comments=0
let g:gruvbox_italicize_strings=0
let g:gruvbox_improved_strings=0
let g:gruvbox_improved_warnings=0
let g:gruvbox_hls_cursor='orange'
silent! colorscheme gruvbox

" ==========================================================
"  Line Highlights
" ==========================================================
highlight CursorLine cterm=NONE ctermbg=black guibg=#151515
highlight CursorColumn cterm=NONE ctermbg=black guibg=#151515
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup end
set laststatus=2
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\

" ==========================================================
"  vim Config
" ==========================================================
set splitright
set splitbelow
set exrc             " allow project specific .vimrc
set secure           " disallow .vimrc not owned by uname
set clipboard=unnamed,unnamedplus
set regexpengine=1
set tabstop=4        " length of a tab
set shiftwidth=4     " length of an indent
set softtabstop=4     " length of an indent
set ruler
set autoindent
set number           " show line numbers
set nornu            " disabling relative numbers
set showmatch        " show matching paranthesis
set backspace=2      " normal editor backspacing
set timeoutlen=1000
set ttimeoutlen=2
set incsearch
set ignorecase       " ignore the case when searching
set smartcase        " case ignored if the search is all lower case
set undolevels=1000  " more undo levels
set scrolloff=7
set shortmess=a      " Decrease the message size
set cmdheight=1      " Change height of the cmd prompt
set redrawtime=20000 " Fixes syntax highlighting on large files
set noshowmode       " No showmode
set mouse=a          " MOUSE MODE
set showtabline=2    " Show tabline
set guioptions-=e    " Don't use GUI tabline
set encoding=UTF-8
let g:autoclose_on=1 " do not autoclose brackets


" show whitespaces
set listchars=tab:--,trail:·,nbsp:~,extends:>,precedes:<,eol:¬
set list


" ==========================================================
"  Post Script
" ==========================================================
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/backup//
set undodir=$HOME/.vim/undodir//
silent execute '!mkdir -p ~/.vim/swapfiles'
silent execute '!mkdir -p ~/.vim/backup'
silent execute '!mkdir -p ~/.vim/undodir'
set rtp+=~/.vim/after
let macvim_skip_colorscheme=1
silent! source ~/.vimrc-local
