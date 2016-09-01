set nocompatible                " Make vim incompatible with the old vi-mode

if has("gui_running")
    " Vundle Settings
    filetype off                  " required

    " set the runtime path to include Vundle and initialize
    set rtp+=$VIM/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    " Define plugins
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'mattn/emmet-vim'
    Plugin 'skammer/vim-css-color'
    Plugin 'Shutnik/jshint2.vim'
    Plugin 'scrooloose/syntastic'
    Plugin 'digitaltoad/vim-pug'

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


    " Syntastic settings
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0


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
    "set guifont=Droid_Sans_Mono:h11
    set guifont=Source_Code_Pro:h12
    set nu                  " display string numbers

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
autocmd BufRead,BufNewFile *.js set tabstop=2 shiftwidth=2

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

" Make keys work with cyrillic keyboard
map ё `
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map . /
map Ё ~
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >
map , ?
map ; $
