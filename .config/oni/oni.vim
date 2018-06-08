set nocompatible                " Make vim incompatible with the old vi-mode

" Vundle Settings
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Define plugins
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'digitaltoad/vim-pug'
Plugin 'godlygeek/tabular'
Plugin 'tomtom/tcomment_vim'
Plugin 'othree/html5.vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'prettier/vim-prettier'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" Put your non-Plugin stuff after this line


" Move to the next tab with Ctrl+Tab
map <C-Tab> :tabnext<CR>
nmap <C-Tab> :tabnext<CR>
imap <C-Tab> <Esc>:tabnext<CR>i

" Move to the previous tab with Ctrl+Shift+Tab
map <C-S-Tab> :tabprevious<CR>
nmap <C-S-Tab> :tabprevious<CR>
imap <C-S-Tab> <Esc>:tabprevious<CR>i


" Set different shiftwidth and tabstop on '.js' files
autocmd BufRead,BufNewFile *.js,*.jsx,*.ts,*.tsx,*.json,*.html,*.css,*.scss,*.sass,*.pug,*.styl set tabstop=2 shiftwidth=2


" Enable matchit plugin which ships with vim and greatly enhances '%'
runtime macros/matchit.vim

" Move cursor at the first symbol of string with Ctrl+Up
map <C-Up> ^
nmap <C-Up> ^
imap <C-Up> <Esc>^i

" Move cursor at the last symbol of string with Ctrl+Down
map <C-Down> $
nmap <C-Down> $
imap <C-Down> <Esc>$i

" Shortcut for commenting
map <C-H> :TComment<CR>
nmap <C-H> :TComment<CR>
imap <C-H> <Esc>:TComment<CR>li

" Disable search highlighting with doulbe Esc
nnoremap <F3> :noh<CR>

" Emmet JSX syntax support
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}

" Ignore patterns mostly for ctrlp plugin
if has("win32")
    set wildignore+=*\\tmp\\*,*\\node_modules\\*,*.swp,*.zip,*.exe,
else
    set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip
endif

" Autorun Prettier on saving file
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.less Prettier

" Workaround for autoread
set autoread
au FocusGained * :checktime
