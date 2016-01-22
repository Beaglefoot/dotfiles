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
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0


    " Set window size, colors, font and hide unnecessary gui in gVim
    set lines=45
    set columns=150
    colorscheme solarized
    set background=light
    set guioptions-=T       " remove toolbar
    set guifont=Droid_Sans_Mono:h10
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
syntax on

" Enable matchit plugin which ships with vim and greatly enhances '%'
runtime macros/matchit.vim

" Make keys work with cyrillic keyboard
map ¸ `
map é q
map ö w
map ó e
map ê r
map å t
map í y
map ã u
map ø i
map ù o
map ç p
map õ [
map ú ]
map ô a
map û s
map â d
map à f
map ï g
map ð h
map î j
map ë k
map ä l
map æ ;
map ý '
map ÿ z
map ÷ x
map ñ c
map ì v
map è b
map ò n
map ü m
map á ,
map þ .
map . /
map ¨ ~
map É Q
map Ö W
map Ó E
map Ê R
map Å T
map Í Y
map Ã U
map Ø I
map Ù O
map Ç P
map Õ {
map Ú }
map Ô A
map Û S
map Â D
map À F
map Ï G
map Ð H
map Î J
map Ë K
map Ä L
map Æ :
map Ý "
map ß Z
map × X
map Ñ C
map Ì V
map È B
map Ò N
map Ü M
map Á <
map Þ >
map , ?
map ; $
