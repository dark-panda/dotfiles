
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible            " Use Vim defaults (much better!)
set bs=indent,eol,start     " allow backspacing over everything in insert mode
set ai                      " always set autoindenting on
set viminfo='20,\"50        " read/write a .viminfo file, don't store more
                            " than 50 lines of registers
set history=50              " keep 50 lines of command line history
set ruler                   " show the cursor position all the time
set background=dark
set tabstop=2
set shiftwidth=2
set expandtab
set vb

if has("autocmd")
  autocmd!

  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif

  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp

  autocmd! BufWritePre * :%s/\s\+$//e
endif

if has("cscope") && filereadable("/usr/bin/cscope")
  set csprg=/usr/bin/cscope
  set csto=0
  set cst
  set nocsverb

  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out

  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin indent on

if &term=="xterm"
  set t_Co=8
  set t_Sb=[4%dm
  set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

au BufNewFile,BufRead *.pgdump setf sql
au BufNewFile,BufRead *.pgsql  setf sql
au BufNewFile,BufRead *.less   setf less
au BufNewFile,BufRead *.scss   setf css
au BufNewFile,BufRead {Gemfile,Guardfile,Capfile}{,.local} setf ruby
au BufNewFile,BufRead *.ru setf ruby
au BufNewFile,BufRead *.jbuilder setf ruby
au BufNewFile,BufRead *.coffee  setf coffee
au BufNewFile,BufRead *.jst    let b:eruby_subtype = "js" | setf eruby
au FileType gitcommit set colorcolumn=80
au FileType gitcommit set spell spelllang=en_ca

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
    \ &tabstop, &shiftwidth, &textwidth)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

set modeline
set modelines=1
set cc=80
let g:local_vimrc=".vimrc_local"

if filereadable($HOME."/.vimrc.local.vim")
  source ${HOME}/.vimrc.local.vim
end

" Move lines...
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

nmap \l :setlocal number!<CR>
nmap \o :set paste!<CR>
nmap \e :NERDTreeToggle<CR>
nmap \q :qall!<CR>
