set nocompatible                " Make vim incompatible with the old vi-mode

" Vundle Settings
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Define plugins
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'raimondi/delimitmate'
Plugin 'clavelito/indent-awk.vim'
Plugin 'prabirshrestha/vim-lsp'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on



" Colors setup
set background=light
set t_Co=16

try
    echo g:colors_name
catch
    hi clear MatchParen
    hi MatchParen ctermfg=7 ctermbg=8
    hi Search term=reverse cterm=NONE ctermbg=11 ctermfg=0 guibg=Yellow
    hi StatusLine cterm=reverse
    hi Visual ctermbg=30
    hi lspReference ctermbg=59
endtry



set nu
set autoread                            " Reload files changed outside of vim
set nobackup                            " Remove the .ext~ files, but not the swapfiles
set backupcopy=yes                      " Make vim compatible with webpack watching mechanism
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

" Enable matchit plugin which ships with vim and greatly enhances '%'
runtime macros/matchit.vim

" Start a new line in insert mode from any cursor position with Ctrl+Enter
imap <C-Enter> <End><Enter>

" Shortcut for commenting
map <C-H> :TComment<CR>
nmap <C-H> :TComment<CR>
imap <C-H> <Esc>:TComment<CR>li

" Ignore patterns mostly for ctrlp plugin
set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip

" Expand brackets, braces, parens with <CR>
let g:delimitMate_expand_cr = 1

" Set up comments for awk filetype
autocmd BufRead,BufNewFile *.awk call tcomment#type#Define("awk", "# %s")

if executable('awk-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'awk-language-server',
        \ 'cmd': {server_info->['awk-language-server']},
        \ 'allowlist': ['awk'],
        \ })
endif
