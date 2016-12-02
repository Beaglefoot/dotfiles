set nocompatible                " Make vim incompatible with the old vi-mode

" Vundle Settings
filetype off                  " required

" set the runtime path to include Vundle and initialize
if has("gui_running")
    set rtp+=$VIM/bundle/Vundle.vim
else
    set rtp+=~/.vim/bundle/Vundle.vim
endif

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Define plugins
Plugin 'scrooloose/nerdtree'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'skammer/vim-css-color'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/syntastic'
Plugin 'digitaltoad/vim-pug'
Plugin 'mxw/vim-jsx'
Plugin 'godlygeek/tabular'
if has("gui_running")
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line



if has("gui_running")
    " Set window size, colors, font and hide unnecessary gui in gVim
    set lines=45
    set columns=150
    let g:solarized_italic=0
    let g:solarized_bold=0
    colorscheme solarized
    set background=light
    set guioptions-=T       " remove toolbar
    set guioptions-=r       " remove right-hand scroll bar
    set guioptions-=L       " remove left-hand scroll bar
    set guifont=Source_Code_Pro:h12,PowerlineSymbols:h12
    let g:airline_powerline_fonts=1
    set nu                  " display string numbers

    " Open NERDTree on start up
    autocmd vimenter * NERDTree

    " Change default NERDTree arrows
    let g:NERDTreeDirArrowExpandable = '▸'
    let g:NERDTreeDirArrowCollapsible = '▾'

    " Move to the next tab with Ctrl+Tab
    map <C-Tab> :tabnext<CR>
    nmap <C-Tab> :tabnext<CR>
    imap <C-Tab> <Esc>:tabnext<CR>i

    " Move to the previous tab with Ctrl+Shift+Tab
    map <C-S-Tab> :tabprevious<CR>
    nmap <C-S-Tab> :tabprevious<CR>
    imap <C-S-Tab> <Esc>:tabprevious<CR>i
else
    colorscheme base16-monokai
endif



" Syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 6
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']

" Make JSX syntax independent of .jsx extension
let g:jsx_ext_required = 0


set autoread                            " Reload files changed outside of vim
set nobackup                            " Remove the .ext~ files, but not the swapfiles
set backspace=indent,eol,start          " Make backspace delete line breaks and auto-indentation
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix                     " Set unix line endings
set fileformats=unix,dos                " Try unix line endings first and then dos ones when read files
set cin                                 " Set C-like indentation
set cinkeys-=0#                         " Indent comments starting with #
set tabstop=4 shiftwidth=4 expandtab    " Tune tab's behaviour and make it a bunch of spaces
set ruler                               " Show the cursor position
set hlsearch                            " Highlight search results
set wildmenu                            " Visualize autocompletion with <TAB>
syntax on

" Remove trailing spaces on saving file
autocmd BufWritePre * :%s/\s\+$//e

" Set different shiftwidth and tabstop on '.js' files
autocmd BufRead,BufNewFile *.js,*.jsx,*.json,*.html,*.css,*.scss,*.sass,*.pug set tabstop=2 shiftwidth=2

" Enable matchit plugin which ships with vim and greatly enhances '%'
runtime macros/matchit.vim

" Start a new line in insert mode from any cursor position with Ctrl+Enter
imap <C-Enter> <End><Enter>

" Move cursor at the first symbol of string with Ctrl+Up
map <C-Up> ^
nmap <C-Up> ^
imap <C-Up> <Esc>^i
"
" Move cursor at the last symbol of string with Ctrl+Down
map <C-Down> $
nmap <C-Down> $
imap <C-Down> <Esc>$i
