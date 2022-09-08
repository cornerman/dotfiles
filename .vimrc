" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" load plugins
if !empty(glob('~/.vimrc.plugin'))
    source ~/.vimrc.plugin
endif

" filetype plugins
filetype plugin indent on

augroup vimrc
    autocmd!
augroup END

" syntax hightlighting
syntax on


" syntax coloring lines that are too long just slows down the world
" set synmaxcol=256

" set mapleader
let mapleader=" "
let maplocalleader = " "

" hides buffers instead of closing them
set hidden

" do not reset position when switching buffers
set nostartofline

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" keep 200 lines of command line history
set history=200

" show the cursor position all the time
set ruler

" display incomplete commands
set showcmd

" redraw lazy
set lazyredraw

" indent wrapped lines
set breakindent
set breakindentopt=shift:2

" tty scroll
if !has('nvim')
    set ttyscroll=3
endif

" live substitution preview
set inccommand=nosplit

" set linenumbers
set number

" don't automagically write on :next
set noautowrite

" do incremental searching
set incsearch

" hightlight all search matches
set hlsearch

" show matching bracket
set showmatch

" we have a fast terminal
set ttyfast

" use the OS clipboard
set clipboard=unnamedplus

" auto. reread file when changed outside of vim
set ar

" ask to save files when closing vim
set confirm

" case insensitive, but be smart
set ignorecase
set smartcase

if ! has('gui_running')
    " leave insert mode quickly
    set ttimeoutlen=0
    augroup FastEscape
        autocmd!
    augroup END

    autocmd FastEscape InsertEnter * set timeoutlen=0
    autocmd FastEscape InsertLeave * set timeoutlen=1000
endif

" keep lines before/beneath cursor
set scrolloff=5
set sidescrolloff=5

" change directory to the current buffer when opening files.
" set autochdir
autocmd vimrc BufEnter * silent! lcd %:p:h

" statusline show last line
set laststatus=2

" dont show mode in second line
set noshowmode

" avoid all hit-enter prompts and shorten some other info prompts
set shortmess=aoOtI

" backspace delete shiftwidth of spaces
set smarttab

" colordepth
set t_Co=256

" tell vim to keep a backup file
set backup

" tagfiles
set tags=./tags;

" prevent backups from overwriting each other. appends reversed path to the
" backup file.
au BufWritePre * let &backupext = '@'.substitute(expand('%:p:h'), '/', '%', 'g').'~'

" Remember info about open buffers on close
" set viminfo^=%

" adjust vim file history https://vi.stackexchange.com/a/26037
set viminfo='10000,<50,s10,h

" tell vim where to put its backup files
set backupdir=~/.vim/tmp

" tell vim where to put swap files
set directory=~/.vim/swp

" persistent undo history across sessions
set undofile
set undodir=~/.vim/undo

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" complete options
set completeopt+=menuone
set completeopt-=preview
set pumheight=8

" formatoptions
autocmd vimrc FileType * setlocal formatoptions=crqnbj

" 8 spaces are bad, use 4 and auto expand them
set expandtab
set tabstop=4
set shiftwidth=4

" always round indents to multiple of shiftwidth
set shiftround

" Turn on the WiLd menu
set wildmenu
set wildignore=*.o,*.d,*~,*.pyc,*.class,target/**
set wildmode=longest,list,full
set wildignorecase

" show invisible chars
set listchars=tab:»·,trail:·,extends:…
set list

" % to also switch between begin/end
runtime macros/matchit.vim

" highlight extra whitespaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd vimrc ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+\%#\@<!$/

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" For all text files set 'textwidth'
set textwidth=0
set wrapmargin=0

" ========colors/appearance
if !empty(glob("~/.vimrc.colors"))
    source ~/.vimrc.colors
else
    set background=dark
endif

" " use background color of terminal
" hi Normal ctermbg=none
" hi NonText ctermbg=none

" only enable cursorline in focused window
set cul
autocmd vimrc WinEnter * set cul
autocmd vimrc WinLeave * set nocul
autocmd vimrc BufEnter * set cul
autocmd vimrc BufLeave * set nocul

" make gvim look like vim :)
if has("gui_running")
    set guifont=Monospace\ 11
    hi Normal guifg=#dcdccc guibg=#3f3f3f
    set guioptions-=m " Remove menu
    set guioptions-=T " Remove toolbar
    set guioptions-=r " Remove right scrollbar
    set guioptions-=e " Use curses rendering for tab pages
    set guioptions+=c " Use curses for simple dialog boxes
    set guioptions-=i " No vim icon
    set guioptions-=L " No left scrollbar
endif

" ========commands/functions

"spelling error
command! W w
command! Q q
command! Wq wq
command! WQ wq

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis

" fix all whitespaces
command! WsFix call WhitespaceFix()
function! WhitespaceFix()
    if !&binary && &filetype != 'diff'
        let l:winview = winsaveview()
        silent! %s/\s\+$//
        call winrestview(l:winview)
    endif
endfunction

" from: http://stackoverflow.com/questions/18157501/toggle-semicolon-or-other-character-at-end-of-line
function! s:ToggleEndChar(charToMatch)
    let save_cursor = getpos(".") " backup cursor
    s/\v(.)$/\=submatch(1)==a:charToMatch ? '' : submatch(1).a:charToMatch
    call setpos('.', save_cursor) " restore cursor
    silent! call repeat#set("\<Plug>ToggleEndChar".a:charToMatch, -1)
endfunction
" noremap! <unique> <Plug>ToggleEndChar; :call <SID>ToggleEndChar(';')<CR>
" noremap! <unique> <Plug>ToggleEndChar, :call <SID>ToggleEndChar(',')<CR>

" toggles the quickfix and location window.
command! Qtoggle call QFixToggle(0)
command! Ltoggle call QFixToggle(1)
function! QFixToggle(loc)
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            lclose
            cclose
            return
        endif
    endfor

    if a:loc
        lopen
    else
        copen
    endif
endfunction

" toggle side effects on yank register when deleting/modifying text
function! DisableSideEffects()
    noremap dd "_dd
    noremap D "_D
    noremap d "_d
    noremap X "_X
    noremap x "_x
    " vnoremap p "_dP
endfunction
function! EnableSideEffects()
    unmap dd
    unmap D
    unmap d
    unmap X
    unmap x
    " vunmap p
endfunction
function! ToggleSideEffects()
    if mapcheck("dd", "n") == ""
        call DisableSideEffects()
        echo 'side effects off'
    else
        call EnableSideEffects()
        echo 'side effects on'
    endif
endfunction
" call DisableSideEffects()
vnoremap p "_dP

" open commands for file lists
command! -complete=file -nargs=* Etabe call s:ETW('tabnew', <f-args>)
command! -complete=file -nargs=* Enew call s:ETW('new', <f-args>)
command! -complete=file -nargs=* Evnew call s:ETW('vnew', <f-args>)
command! -complete=file -nargs=* E call s:ETW('edit', <f-args>)
function! s:ETW(what, ...)
    if empty(a:000)
        edit
        return
    endif

    for f1 in a:000
        let files = glob(f1)
        if files == ''
            execute a:what . ' ' . escape(f1, '\ "')
        else
            for f2 in split(files, "\n")
                execute a:what . ' ' . escape(f2, '\ "')
            endfor
        endif
    endfor
endfunction

" return to last edit position when opening a file.
" except for git commits: Enter insert mode instead.
autocmd vimrc BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   if &filetype == 'gitcommit' |
\       setlocal spell |
\   else |
\      exe "normal! g`\"" |
\    endif |
\ endif

" ========keybindings

" MapFastKeycode: helper for fast keycode mappings
" makes use of unused vim keycodes <[S-]F15> to <[S-]F37>
function! <SID>MapFastKeycode(key, keycode)
    if s:fast_i == 46
        echohl WarningMsg
        echomsg "Unable to map ".a:key.": out of spare keycodes"
        echohl None
        return
    endif
    let vkeycode = '<'.(s:fast_i/23==0 ? '' : 'S-').'F'.(15+s:fast_i%23).'>'
    exec 'set '.vkeycode.'='.a:keycode
    exec 'map '.vkeycode.' '.a:key
    exec 'imap '.vkeycode.' '.a:key
    let s:fast_i += 1
endfunction
let s:fast_i = 0

call <SID>MapFastKeycode('<S-Tab>', "\e}")
call <SID>MapFastKeycode('<C-Tab>', "\e{")
call <SID>MapFastKeycode('<M-q>', "\eq")
call <SID>MapFastKeycode('<M-h>', "\eh")
call <SID>MapFastKeycode('<M-j>', "\ej")
call <SID>MapFastKeycode('<M-k>', "\ek")
call <SID>MapFastKeycode('<M-l>', "\el")
call <SID>MapFastKeycode('<M-d>', "\ed")
call <SID>MapFastKeycode('<M-n>', "\en")

" toggle sideffects
nnoremap <leader><space> :call ToggleSideEffects()<CR>

" clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>:echo<CR>

" save some keystrokes
" nnoremap ; :
" nnoremap , ;
nnoremap \ :update<CR>
nnoremap <leader>\ :w suda://%<CR>:checktime<CR>
nnoremap - _
nnoremap + @m
nnoremap _ qm

"w!! writes file with root rights
" cnoremap w!! w !sudo tee % >/dev/null

" break undo in insert mode
inoremap <C-U> <C-G>u

" switch buffers/tabs
nnoremap <Backspace> :bprevious<CR>
nnoremap <Enter> :bnext<CR>
nnoremap <C-q> <C-^>
nnoremap Q :bdelete<CR>
nnoremap gqq <S-v>gq

" switch to numbered buffer
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" easier split window navigation
nnoremap <C-j>     <C-w>j
nnoremap <C-k>     <C-w>k
nnoremap <C-h>     <C-w>h
nnoremap <C-l>     <C-w>l

" keep selection when indenting
vnoremap < <gv
vnoremap > >gv

" Y yanks till end of line
nnoremap Y y$

" paste over rest of line
nnoremap <leader>p v$hp

" overwrite :e with :E
cabbrev e <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'E' : 'e')<CR>

" delete everything but selection
vnoremap <leader>x :<C-U>1,'<-1:delete<CR>:'>+1,$:delete<CR>
nnoremap <leader>x <S-v>:<C-U>1,'<-1:delete<CR>:'>+1,$:delete<CR>

" fast way to edit ~/.vimrc*
nnoremap <Leader>vv :e ~/.vimrc<CR>
nnoremap <Leader>vp :e ~/.vimrc.plugin<CR>
nnoremap <Leader>vl :e ~/.vimrc.local<CR>
nnoremap <Leader>vz :e ~/.zshrc<CR>
nnoremap <Leader>vzl :e ~/.zshrc.local<CR>
nnoremap <Leader>va :e ~/.zaliases<CR>
nnoremap <Leader>vr :source ~/.vimrc<CR>

" toggle chars at end of line
nmap <silent> <Leader>< <Plug>ToggleEndChar;
nmap <silent> <Leader>, <Plug>ToggleEndChar,

" kind of reverse of J
" nmap K i<CR><ESC>

" c+s corrects the last word
inoremap <c-s> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <c-s> 1z=

" Smart Home:
" https://vi.stackexchange.com/a/23206
noremap  <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "^"
inoremap <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "\<C-O>^"
noremap  <expr> 0 col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "^"
" inoremap <expr> 0 col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "\<C-O>^"

autocmd vimrc BufEnter * set noreadonly " no delay

" local settings
if !empty(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
