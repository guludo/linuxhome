filetype indent on 
set tabstop=4
set number
set expandtab
set shiftwidth=4
set colorcolumn=80
set smartindent
"set tw=100
set undodir=~/.vim/undodir
set undofile
set laststatus=2
set completeopt+=longest
syntax on
set clipboard=unnamedplus,exclude:cons\|linux

" bash-like path command line completion
set wildmode=longest,list

autocmd FileType make setlocal noexpandtab
autocmd FileType cmake map <buffer> K :!man --pager="less -p '^   <cword>'" cmake-commands<CR>
autocmd FileType make map <buffer> K :!info make <cword><CR>
autocmd BufNewFile,BufRead *.gawk :set syntax=awk
autocmd FileType gitcommit set colorcolumn=72
autocmd FileType gitcommit set tw=72

autocmd BufRead,BufNewFile wscript setfiletype python

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

set hlsearch

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
hi Folded ctermbg=232 ctermfg=236

" Mappings
map <C-H> :bp<CR>
map <C-L> :bn<CR>
map <C+J> :wn
map <C-N> :b #<CR>

" Escape insert mode easily
inoremap jk <Esc>

" pathogen (see https://github.com/tpope/vim-pathogen.git)
execute pathogen#infect()

colorscheme nord

" Highlighting customizations
hi rstSections cterm=bold

let g:airline_powerline_fonts = 1

let g:ycm_global_ycm_extra_conf = '~/.ycm_global_extra_conf.py'

" Running from Vim
" For custom run commands, please create Run command by using :com
function! Run()
    if exists(":Run")
        :Run
    else
        :!%:p
        if v:shell_error != 0
            echo "Unsuccessful file execution, you might want to create a command called Run"
        endif
    endif
endfunc

" Mapping Ctrl+Enter to call Run()
map <NL> :call Run()<CR>

" Use ~/.vimrc.local for non-general configuration
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Use .vimrc.local for specific directory configuration
if getcwd() != expand("~") && filereadable(".vimrc.local")
    source .vimrc.local
endif
