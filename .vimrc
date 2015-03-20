filetype indent on 
set tabstop=4
set number
set expandtab
set shiftwidth=4
set colorcolumn=101
set smartindent
"set tw=100
set undodir=~/.vim/undodir
set undofile
        
syntax on

if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

colorscheme delek
highlight Comment ctermfg=8
highlight ColorColumn ctermbg=0

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
hi Folded ctermbg=232 ctermfg=236

" Mappings
map <F7> :tabp<CR>
map <F8> :tabn<CR>
map <C-H> :tabp<CR>
map <C-L> :tabn<CR>
map <C+J> :wn

" Edit vimrc
com! Vimrc edit ~/.vimrc

" My Commands
com! -bar FixBlocks %s/\([^ ]\){/\1 {/e
com! -bar FixBlocks2 %s/}\([^ ]\)/} \1/e
com! -bar FixWhile %s/while(/while (/ge
com! -bar FixCatch %s/catch(/catch (/ge
com! -bar FixFor %s/for(/for (/ge
com! -bar FixIf %s/if(/if (/ge
com! -bar FixSwitch %s/switch(/switch (/ge
com! -bar FixSpace %s/\s\+$//ge
com! -bar FixBlockStart %s/\n *{/ {/e
com! -bar FixExtraLines %s/\n\n\n\+/\r\r/e

com! -bar JavaStyle FixBlocks | FixBlocks2 | FixWhile | FixCatch | FixFor | FixIf | FixSwitch |
        \ FixSpace | FixBlockStart | FixExtraLines

" pathogen (see https://github.com/tpope/vim-pathogen.git)
execute pathogen#infect()

" Clear signs
function! ClearSigns()
    let bufferNumber = 1
    while bufexists(bufferNumber)
        if bufname(bufferNumber)
            :execute "sign unplace * file=" . bufname(bufferNumber)
        endif 
        let bufferNumber+=1
    endwhile
endfunction
com! ClearSigns :call ClearSigns()

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


" Python utils
function! GotoIndentTop()
    let linestr = getline(line('.'))
    let indentSize = strlen(substitute(linestr, "[^ ].*", "", ""))
    if indentSize > 0
        execute "normal " . line('.') . "G"
        execute "?^ \\{0," . (indentSize-1) . "\\}[^ ]"
    else
       :echo "Already on top indentation level" 
    endif
endfunc
com! -bar Top call GotoIndentTop()
map gt :Top<CR>


" Use ~/.vimrc.local for non-general configuration
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Use .vimrc.local for specific directory configuration
if getcwd() != expand("~") && filereadable(".vimrc.local")
    source .vimrc.local
endif
