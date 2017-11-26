" ⮀∿     --- VIM Configuration with Vundle ---    ∿⮀
set nocompatible
filetype off
syntax on


" Map space to leader instead of "\"
let mapleader = "\<Space>"
" In edit mode double space to switch to visual
nmap <Leader><Leader> V
" Use leader w instead of ctrl-w to switch windows
nmap <Leader>w <c-w>

" --------------------------------------------------------------------
" set the runtime path to include Vundle and initialize
if has('win32') || has('win64') || has('win32unix')
  set rtp+=$HOME/.vim/bundle/Vundle.vim/
  call vundle#begin('$HOME/.vim/bundle/')
else
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
endif

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" --------------------------------------------------------------------
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" --------------------------------------------------------------------
" My Plugins
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-sensible'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list=1
map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Vim expand selection
Plugin 'terryma/vim-expand-region'
" v to select 1 char, v again to expand, and on and on
vmap v <Plug>(expand_region_expand)
" C-v to reduce the region
vmap <C-v> <Plug>(expand_region_shrink)

Plugin 'tomtom/tlib_vim'
Plugin 'scrooloose/nerdtree'
map <Leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
Plugin 'scrooloose/nerdcommenter'
Plugin 'godlygeek/tabular'

" press a then = to align on =
vmap a= :Tabularize /=<CR>
" press a then ; to align on ::
vmap a; :Tabularize /::<CR>
" press a then - to align on ->
vmap a- :Tabularize /-><CR>

Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

" VimProc & Neocomplete
if has('unix') && !has('win32unix')
  Plugin 'Shougo/vimproc.vim'
endif
Plugin 'Shougo/neocomplete'
" Vim-Airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Color Scheme: Vim-Hybrid-Material 
Plugin 'kristijanhusak/vim-hybrid-material'
" Gutter
Plugin 'airblade/vim-gitgutter'
" Vim-JavaScript
Plugin 'pangloss/vim-javascript'

" ----- END VUNDLE --------------------------------------------------
call vundle#end()

filetype plugin indent on

set nocompatible
set number
set nowrap
set showmode
set tw=80
set smartcase
set smarttab
set smartindent
set autoindent
set softtabstop=2
set shiftwidth=2
set expandtab
set incsearch
set mouse=a
set history=1000
set clipboard=unnamedplus,autoselect
set completeopt=menuone,menu,longest
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest
set cmdheight=1
"style and colorscheme
set t_Co=256
set background=dark
colorscheme hybrid_material
set linespace=8
set guifont=Range\ Mono\ Light:h13
let g:enable_bold_font = 1
let g:airline_theme = "hybrid"

let g:airline#extensions#tabline#enabled = 1


" VIM GUTTER
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_added = '❖'
highlight GitGutterAdd guifg = '#A3E28B'

" JAVASCRIPT HIGHLIGHTING -------------------------------------------
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 0
let g:javascript_plugin_ngdoc = 0
" Toggle the conceallevel
map <leader>l :exec &conceallevel ? "set conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:javascript_conceal_noarg_arrow_function = "🞅"
let g:javascript_conceal_underscore_arrow_function = "🞅"
if has('win32') || has('win64') || has('win32unix')
  let g:javascript_conceal_return               = "⇚"
  let g:javascript_conceal_NaN                  = "ℕ"
else
  let g:javascript_conceal_return               = "߷"
  let g:javascript_conceal_NaN                  = "⸎"
endif
