" Houcheng Lee's .vimrc (03/29/2011)

set nocompatible		" use VIM not vi setting

" fix backspace key won't move from current line
set backspace=indent,eol,start

set autoindent			" always set autoindenting on
set nobackup
set history=50			" keep 50 lines of command line history
set ruler				" show the cursor position all the time
set showcmd				" display incomplete commands
set incsearch			" do incremental searching
set vb t_vb=			" set no visual bell and disable screen flash
set autowrite			" automatically save changes when jumping from file to file

map! ii <esc>							" map ii to Esc
map <F6> :let &hlsearch=!&hlsearch<CR>	" Turn hlsearch on or off by <F6>
map ,e :update<CR>:e#<CR>               " toggle between % and # files, update only save when buffer changes
"nnoremap <CR> o<esc>                    " insert blank lines without being into insert mode (such as o), cause quickfix Enter jump failed

" set ctrl+s to save file
" ctrl+s, and ctrl+q are flow-control characters, 
" so have to set stty -ixon and ixoff in bash to turn them off
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

"
" grep, find
"
" grep current cursor word in ONLY .c, .h, .cc or .cpp file
nnoremap ,g :grep -nr <C-R><C-W> `find . -name "*.[ch]" -o -name "*.cc" -o -name "*.cpp"`<CR> 
command! -nargs=1 Grep :call Grep("<args>") 
command! -nargs=* Find :call Find(<f-args>)
"
" ctags
"
nmap ,t :!(cd %:p:h;ctags *.[ch])&		" rebuild the tag file in the directory of the current source file
set tags=./tags,tags,~/rohc/rohc/tags	" set the sequence of what tags file to use
set cscopequickfix=s-,c-,d-,i-,t-,e-	" show the Cscope result into the quickfix window
"
" Windows operations
"
" and map some key to maximize the left or right working windows, and up or
" down working windows.
set winminheight=0
set winminwidth=0
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W><bar>
map <C-L> <C-W>l<C-W><bar>
map ,w <C-W><C-W>			",w toggle between vertical or horizonal windows
map ,h <C-W>h
map ,l <C-W>l
map ,k <C-W>k
map ,j <C-W>j

"
" Section: Plugin Setting
"
" YankRing.vim - display a buffer displaying the yankring's contents
nnoremap <silent> <F4> :YRShow<CR>
" NERD_commenter.vim (change the <leader> from default \ to ,)
let mapleader = "," 
" taglist.vim
let Tlist_WinWidth = 25
nnoremap <silent> <F8> :Tlist<CR>
" NERD_tree.vim 
nmap <leader>t :NERDTreeToggle<CR>	" key binding ,t for NERD Tree toggle
"
" Section: File Syntax
"
au BufRead,BufNewFile *.pc set filetype=c	"*.pc file use c syntax file
hi Search ctermfg=0 ctermbg=2				"change the default hi-light color
" When editing a file, always jump to the last cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"autocmd BufReadPost *
      "\ if ! exists("g:leave_my_cursor_position_alone") |
      "\     if line("'\"") > 0 && line ("'\"") <= line("$") |
      "\         exe "normal g'\"" |
      "\     endif |
      "\ endif


"
" Section: Spell Check Setting (after vim 7.0, spell check is build-in feature)
"
set spellfile=~/.vim/spellfile.add
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

"
" Section: Conditional Setting
"
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  filetype plugin indent on
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
endif " has("autocmd")

"
" Section: functions
"
" Usage: :Grep [pattern], use grep search recursively and execlude .svn
function! Grep(name)
	let cmd_output = system("grep -nIR '".a:name."' * | grep -v .svn")
	let tmpfile = tempname()
	exe "redir! > " . tmpfile
	silent echon cmd_output
	redir END
	let old_efm = &efm
	"Need to set this instead of set efm=%f, or file cannot be opened in
	"Quickfix window
	set efm=%f:%\\s%#%l:%m

	if exists(":cgetfile")
		execute "silent! cgetfile " . tmpfile
	else
		execute "silent! cfile " . tmpfile
	endif

	let &efm = old_efm
	botright copen
	call delete(tmpfile)
endfunction

" Find file in current directory and edit it.
function! Find(...)
  let path="."
  if a:0==2
    let path=a:2
  endif
  let l:list=system("find ".path. " -name '".a:1."' | grep -v .svn ")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:1."' not found"
    return
  endif
  if l:num == 1
    exe "open " . substitute(l:list, "\n", "", "g")
  else
    let tmpfile = tempname()
    exe "redir! > " . tmpfile
    silent echon l:list
    redir END
    let old_efm = &efm
    set efm=%f

    if exists(":cgetfile")
        execute "silent! cgetfile " . tmpfile
    else
        execute "silent! cfile " . tmpfile
    endif

    let &efm = old_efm

    " Open the quickfix window below the current window
    botright copen

    call delete(tmpfile)
  endif
endfunction


"
" Tab Setting
"
" Cause the program to indent to 4 spaces but actually is ^I,tab.
" cindent will see tabstop value, so I have to set it to 4
" be careful when you press <tab> it will insert 2 ^I, so you have to use
" Ctrl-V<tab> if you only want a <tab>
" if( you want to use tab as ident ){
set tabstop=4    
set softtabstop=4
set shiftwidth=4
" else if( you want space to use as ident){
" If you want all spaces and no tab
"set shiftwidth=4  " use 4 spaces as ident
"set expandtab
" }
" The 'expandtab' option will trouble the Makefile,
" so turn off the expandtab option when editing Makefile.
au FileType make setlocal noexpandtab


"
" Section: memo
"
" 1. Use 'set list' to show the hidden character.<Tab>=^I, '\n'=$.
"
" 2. Use 'set tabstop=3' will let the <Tab> trasfer to 3 spaces when we look 
"    at them on screen. Actually, it is still a ^I chacacter. Reseting the
"    tabstop will affect the whole existing <Tab>s.
"
" 3. Use 'set softtabstop=3'. This will transfer <Tab> into 3 spaces whenever
"    you push <Tab> key. But if you push <Tab> 3 times continuely, you will 
"    get ^I and 1 space instead of 9 spaces.
"
" 4. default <leader> is \, so <leader>w is \w
"    e.g. map <leader>w <C-W><C-W>
"
" 5. highlight the line where cursor is in,
"    Use HiCurLine.vim plugin. \hcli to turn on, \hcls to stop
"
" 6. set expandtab
"    Let all new insert tab become 4 spaces, no matter what condition.
"    Set 'expandtab on' will not affect the previous enter <Tab>
"    This would be horrible if you want to use really <Tab>.
"    If you want to enter a real tab character, use Ctrl-V<Tab> key sequence.
"    You can find some reference in Tip#12 in www.vim.org

"
" Section: Backup
"
"map _p :Ide print <C-R>=expand("<cword>")<CR><CR>
"map _b :exe 'Ide break ' .expand("%:t"). ':' .line(".")<CR>
"map _u :exe 'Ide until ' .expand("%:t"). ':' .line(".")<CR>
" Avoid annoying hi-light color when searching
"hi Search         cterm=reverse  ctermfg=0  ctermbg=2
"hi Visual         term=reverse cterm=reverse guifg=khaki guibg=olivedrab

" Not using showmarks.vim anymore (2010/01/30)
" set showmarks.vim plugin 
"let g:showmarks_enable = 0
"let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`"
"hi default ShowMarksHLl ctermfg=cyan ctermbg=black cterm=bold guifg=blue guibg=lightblue gui=bold
"hi default ShowMarksHLu ctermfg=cyan ctermbg=black cterm=bold guifg=blue guibg=lightblue gui=bold
"hi default ShowMarksHLo ctermfg=cyan ctermbg=black cterm=bold guifg=blue guibg=lightblue gui=bold

" Make p in Visual mode replace the selected text with the "" register.
" vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"set nowrap				" do no wrap line

" When editing a file, always jump to the last cursor position
"autocmd BufReadPost *
      "\ if ! exists("g:leave_my_cursor_position_alone") |
      "\     if line("'\"") > 0 && line ("'\"") <= line("$") |
      "\         exe "normal g'\"" |
      "\     endif |
      "\ endif
