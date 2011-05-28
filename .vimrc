" Houcheng Lee's .vimrc (04/02/2011)

" enable pathogen.vim to load vim scripts in bundle/
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


"
" Section: VIM Settings
"
set nobackup
set nocompatible		" use VIM not vi setting
set autoindent			" always set autoindenting on
set history=50			" keep 50 lines of command line history
set ruler				" show the cursor position all the time
set showcmd				" display incomplete commands
set incsearch			" do incremental searching
set hlsearch			" highlighting search 
set vb t_vb=			" set no visual bell and disable screen flash
set noerrorbells		" set no error bells
set novisualbell		" set no visual bell
set autowrite			" automatically save changes when jumping from file to file
set autoread			" automatically read changes when it's changed from outside
set copyindent			" copy the previous indentation on autoindenting
set ignorecase			" ignore case when searching
set smartcase			" ignore case if search pattern is all lowercase,case-sensitive otherwise
set backspace=indent,eol,start " fix backspace key won't move from current line

let mapleader = ","		"set leader to , instead of default \
let g:mapleader = "," 

filetype plugin indent on  " enable filetype-specific detection, indenting, and plugins
autocmd! bufwritepost .vimrc source ~/.vimrc " auto reload vimrc when editing it


"
" Section: Key Mapping
"
map! ii <esc>							" map ii to Esc
map <leader>e :update<CR>:e#<CR>               " toggle between % and # files, update only save when buffer changes

" set ctrl+s to save file
" ctrl+s, and ctrl+q are flow-control characters, 
" so have to set stty -ixon and ixoff in bash to turn them off
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" replace the current word in all opened buffers
map <leader>r :call Replace()<CR>

" grep current cursor word in ONLY .c, .h, .cc or .cpp file
nnoremap <leader>g :grep -nr <C-R><C-W> `find . -name "*.[ch]" -o -name "*.cc" -o -name "*.cpp"`<CR> 
command! -nargs=1 Grep :call Grep("<args>") 
command! -nargs=* Find :call Find(<f-args>)

" ctags
" rebuild the tag file in the directory of the current .c and .h file
nmap ,t :!(cd %:p:h;ctags *.[ch])&<CR>
" build tags of my own cpp project 
nmap \t :!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>

set tags=./tags,tags					" set the sequence of what tags file to use
set cscopequickfix=s-,c-,d-,i-,t-,e-	" show the Cscope result into the quickfix window

" Windows operations  :help window-resize
set winminheight=0
set winminwidth=0
map <C-J> <C-W>j<C-W>_		" maximize the down, up, left or right window
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W><bar>
map <C-L> <C-W>l<C-W><bar>
map <leader>h <C-W>h				" move to the left, right, up or down window
map <leader>l <C-W>l
map <leader>k <C-W>k
map <leader>j <C-W>j
map <leader>w <C-W><C-W>			" ,w toggle between vertical or horizonal windows

" tab
map <C-t><C-t> :tabnew<CR>
map <C-t><C-w> :tabclose<CR> 

" ,/ turn off search highlighting
nmap <leader>/ :nohl<CR>

" ,p toggles paste mode
nmap <leader>p :set paste!<BAR>set paste?<CR>

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" open Quickfix console
map \cc :botright copen<CR> 
map \] :cn<CR>		" move to next error
map \[ :cp<CR>		" move to the prev error

" Ctrl-[ jump out of the tag stack (undo Ctrl-])
"map <C-[> <ESC>:po<CR>

" \g generates the header guard
map \g :call IncludeGuard()<CR>


"
" Section: Plugin Setting
"
" YankRing.vim - display a buffer displaying the yankring's contents
"nnoremap <silent> <F4> :YRShow<CR>

" NERD_commenter.vim (change the <leader> from default \ to ,)

" taglist.vim
let Tlist_WinWidth = 25
nnoremap <silent> <F8> :Tlist<CR>

" NERD_tree.vim 
nmap <leader>n :NERDTreeToggle<CR>	" key binding ,t for NERD Tree toggle

" The following is from Vgod's
" vim-latex - many latex shortcuts and snippets {
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash
set grepprg=grep\ -nH\ $*
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
" have to set -file-line-error-style flag to let compiled error in quickfix work
let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode -file-line-error-style $*'
" vim has to be compiled as python supported, or Compilation functions such as (\ref, \cite)
" can only open quickfix and preview windows which are not usual,
" because texviewer.vim invokes outline.py to present citiation layout
"let g:Tex_UsePython=0 " set this to test

"}

" AutoClose - Inserts matching bracket, paren, brace or quote 
" fixed the arrow key problems caused by AutoClose
if !has("gui_running")	
"   set term=linux
   imap [A <ESC>ki
   imap [B <ESC>ji
   imap [C <ESC>li
   imap [D <ESC>hi

   nmap [A k
   nmap [B j
   nmap [C l
   nmap [D h
endif


" SuperTab
let g:SuperTabDefaultCompletionType = "context"

"OmniCppComplete
set tags+=~/.vim/tags/cpp_stl3.3.tags

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview


"
" Section: File Syntax
"
syntax on
au BufRead,BufNewFile *.pc set filetype=c	" *.pc file use c syntax file


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
" Section: Functions
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

"--------------------------------------------------------------------------- 
" Tip #382: Search for <cword> and replace with input() in all open buffers 
"--------------------------------------------------------------------------- 
fun! Replace() 
    let s:word = input("Replace " . expand('<cword>') . " with:") 
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge' 
    :unlet! s:word 
endfun 

fun! IncludeGuard()
   let basename = substitute(bufname(""), '.*/', '', '')
   let guard = '_' . substitute(toupper(basename), '\.', '_', "H")
   call append(0, "#ifndef " . guard)
   call append(1, "#define " . guard)
   call append( line("$"), "#endif // for #ifndef " . guard)
endfun


"
" Section: Tab Setting
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
" Section: Vgod's settings
"
set clipboard=unnamed	" yank to the system register (*) by default
set showmatch			" Cursor shows matching ) and }
set showmode			" Show current mode
set wildchar=<TAB>		" start wild expansion in the command line using <TAB>
set wildmenu            " wild char completion menu

" ignore these files while expanding wild chars
set wildignore=*.o,*.class,*.pyc

" status line {
set laststatus=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction

"}

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Enable omni completion. (Ctrl-X Ctrl-O)
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType java set omnifunc=javacomplete#Complete

" use syntax complete if nothing else available
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
              \	if &omnifunc == "" |
              \		setlocal omnifunc=syntaxcomplete#Complete |
              \	endif
endif

" make CSS omnicompletion work for SASS and SCSS
autocmd BufNewFile,BufRead *.scss             set ft=scss.css
autocmd BufNewFile,BufRead *.sass             set ft=sass.css

"--------------------------------------------------------------------------- 
" ENCODING SETTINGS
"--------------------------------------------------------------------------- 
set encoding=utf-8                                  
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,latin1

fun! ViewUTF8()
	set encoding=utf-8                                  
	set termencoding=big5
endfun

fun! UTF8()
	set encoding=utf-8                                  
	set termencoding=big5
	set fileencoding=utf-8
	set fileencodings=ucs-bom,big5,utf-8,latin1
endfun

fun! Big5()
	set encoding=big5
	set fileencoding=big5
endfun

if has("gui_running")	" GUI color and font settings
"  set guifont=Osaka-Mono:h20
"  set guifont=Consolas:h14
  set guifont=Courier:h14
"  set background=dark 
"  set t_Co=256          " 256 color mode
  set cursorline        " highlight current line
"  colors moria
else
" terminal color settings
  colors vgod
endif

" Bash like keys for the command line
"cnoremap <C-A>      <Home>
"cnoremap <C-E>      <End>
"cnoremap <C-K>      <C-U>

" :cd. change working directory to that of the current file
"cmap cd. lcd %:p:h

" Writing Restructured Text (Sphinx Documentation) {
   " Ctrl-u 1:    underline Parts w/ #'s
"   noremap  <C-u>1 yyPVr#yyjp
"   inoremap <C-u>1 <esc>yyPVr#yyjpA
   " Ctrl-u 2:    underline Chapters w/ *'s
"   noremap  <C-u>2 yyPVr*yyjp
"   inoremap <C-u>2 <esc>yyPVr*yyjpA
   " Ctrl-u 3:    underline Section Level 1 w/ ='s
"   noremap  <C-u>3 yypVr=
"   inoremap <C-u>3 <esc>yypVr=A
   " Ctrl-u 4:    underline Section Level 2 w/ -'s
"   noremap  <C-u>4 yypVr-
"   inoremap <C-u>4 <esc>yypVr-A
   " Ctrl-u 5:    underline Section Level 3 w/ ^'s
"   noremap  <C-u>5 yypVr^
"   inoremap <C-u>5 <esc>yypVr^A
"}
" C/C++ specific settings
"autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30


"
" Section: Memo
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
" 4. set expandtab
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

"set smarttab		" insert tabs on the start of a line according to context
"
" When editing a file, always jump to the last cursor position
"autocmd BufReadPost *
      "\ if ! exists("g:leave_my_cursor_position_alone") |
      "\     if line("'\"") > 0 && line ("'\"") <= line("$") |
      "\         exe "normal g'\"" |
      "\     endif |
      "\ endif

