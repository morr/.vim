"-----------------------------------------------------------------------------
" pathogen
"-----------------------------------------------------------------------------
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype on

"-----------------------------------------------------------------------------
" fugitive
"-----------------------------------------------------------------------------
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete
set diffopt+=vertical

"-----------------------------------------------------------------------------
" supertab
"-----------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = '<C-n>'

"-----------------------------------------------------------------------------
" syntastic
"-----------------------------------------------------------------------------
"let g:syntastic_ruby_checkers=['mri'] ", 'rubylint', 'rubocop'
"let g:syntastic_ruby_mri_args='-T1 -c'
let g:syntastic_coffee_checkers=['coffee'] ", 'coffeelint'
let g:syntastic_slim_checkers=['slimrb']
let g:syntastic_json_checkers=['jsonlint'] " npm install -g jsonlint
let g:syntastic_sass_checkers=[]
let g:vim_json_syntax_conceal = 0
let g:syntastic_ruby_mri_exec = 'ruby2.2.2'
let g:syntastic_ruby_mri_quiet_messages = {
\ 'regex': [
\   '\m`&'' interpreted as argument prefix',
\   '\m`*'' interpreted as argument prefix'
\ ] }
"\   '\m^shadowing outer local variable',
"let g:syntastic_enable_signs=1
"let g:syntastic_auto_loc_list=1

"-----------------------------------------------------------------------------
" matchit
"-----------------------------------------------------------------------------
runtime macros/matchit.vim

"-----------------------------------------------------------------------------
" powerline
"-----------------------------------------------------------------------------
let g:airline_powerline_fonts = 1
set laststatus=2

"-----------------------------------------------------------------------------
" buffergator
"-----------------------------------------------------------------------------
let g:buffergator_suppress_keymaps = 1
nnoremap <silent> <Leader>b :BuffergatorToggle<CR>
"-----------------------------------------------------------------------------
" Command-T
"-----------------------------------------------------------------------------
let g:CommandTMatchWindowReverse = 0
let g:CommandTMaxHeight = 17
let g:CommandTMaxFiles = 25000
let g:CommandTWildIgnore = &wildignore."*.o,*.obj,.git,.svn,*.log,public/uploads/**,public/system/**,public/images/**,tmp/cache/**,tmp/miniprofiler/**,public/assets/**,tmp/sass-cache/**,tmp/pages/**,tmp/cache/**,test/pages/**,spec/pages/**"

nmap <silent> <leader>t :CommandT<cr>
nmap <silent> <leader>r :CommandTFlush<cr>:CommandT<cr>
nmap <silent> <leader>j :CommandTJump<CR>

nmap <f1> :CommandT<cr>
nmap ,<f1>r :CommandTFlush<cr>:CommandT<cr>

" буферы закрываем всегда
"function! s:set_bufhidden()
  "if empty(&buftype)
    "setlocal bufhidden=wipe
  "endif
"endfunction

"autocmd! BufRead * call s:set_bufhidden()

"-----------------------------------------------------------------------------
" LustyExplorer
"-----------------------------------------------------------------------------
nmap <silent> <leader>l :LustyBufferGrep<cr>
nmap <f4> :LustyBufferGrep<cr>

silent! unmap <leader>lf
silent! unmap <leader>lr
silent! unmap <leader>lb
silent! unmap <leader>lg
silent! unmap <leader>lj

"-----------------------------------------------------------------------------
" NerdTree
"-----------------------------------------------------------------------------
map <silent> <leader>n :NERDTreeToggle<cr>
map <silent> <leader>N :NERDTreeFind<cr>
nmap <f2> :NERDTreeFind<cr>
nmap <f3> :NERDTreeToggle<cr>

"-----------------------------------------------------------------------------
" NerdCommenter
"-----------------------------------------------------------------------------
let NERDSpaceDelims = 1

"-----------------------------------------------------------------------------
" EasyMotion
"-----------------------------------------------------------------------------
let g:EasyMotion_enter_jump_first = 1
map ; <Plug>(easymotion-s)
"map <c-;> <Plug>(easymotion-repeat)

"-----------------------------------------------------------------------------
" Ag
"-----------------------------------------------------------------------------
let g:ag_search_ignore = 'log,public,tmp,spec/vcr_cassettes,vendor/'
let g:ag_prg="ag --nogroup --nocolor --column "
let g:ag_qhandler="copen 12"
map <Leader>/ <esc>:call AgSearch()<cr>

function! AgSearch()
  let l:search_phrase=input('Ag ')
  redraw
  echo "Ack Searching..."
  silent execute ':Ag --ignore-dir={'.g:ag_search_ignore.'} '.l:search_phrase
endfunction

"-------------------------------------------------------------------------------
" vim-rails
"
" example projections: https://gist.github.com/henrik/5676109
"-------------------------------------------------------------------------------

nmap <F4> :A<CR>
nmap <Leader><F4> :AV<CR>

let g:rails_projections = {
\   'app/admin/*.rb': {
\     'alternate': 'spec/controllers/admin/{}_controller_spec.rb'
\   },
\   'spec/controllers/admin/*_controller_spec.rb': {
\     'alternate': 'app/admin/{}.rb'
\   },
\ }

"-----------------------------------------------------------------------------
" editing
"-----------------------------------------------------------------------------
set cpoptions+=$
set colorcolumn=81

"-----------------------------------------------------------------------------
" other options
"-----------------------------------------------------------------------------
set nocompatible
set backup
set nowrap
set history=9999
set undolevels=9999
filetype plugin on
" directory for swap files
set directory=$HOME
" russian language fix
set langmap=ё`,йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,фa,ыs,вd,аf,пg,рh,оj,лk,дl,э',яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,Ё~,ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж:,Э\\",ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>
" one word symbol class
set iskeyword=@,48-57,_,192-255,\$,\-
" encodings
set fileencodings=utf-8,windows-1251,iso-8859-15,koi8-r
" fileformat
"set fileformats=dos
" sessions
set sessionoptions=curdir,buffers,tabpages,folds,options,resize,globals,localoptions
"set noeol bin
" keep more context when scrolling off the end of a buffer
" indents
"set cindent
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
                  "    shiftwidth, not tabstop
set nojoinspaces
set smartindent
set expandtab
set shiftwidth=2  " number of spaces to use for autoindenting

set softtabstop=2
set tabstop=2
set softtabstop=2
" search
set incsearch
set hlsearch
set showmatch
" clipboard
"set clipboard=unnamedplus
"set noignorecase
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
set noswapfile
" gui
syntax on
set t_Co=256
colors ir_black_morr
"colors sebocean
if has("mac")
  "set guifont=Source\ Code\ Pro:h14
  "set guifont=Monaco:h14
  " download Monaco for Powerline.otf from https://gist.github.com/baopham/1838072
  set guifont=Monaco\ for\ Powerline:h14
elseif has("gui_gtk2")
  set guifont=Monaco\ 12
else
  set guifont=Monaco:h10
endif
" strings numeration
set number " always show line numbers
set guioptions-=T
set guioptions+=c " disable some gui popups
set ch=1
" set noguipty
set nostartofline
set whichwrap+=>
set whichwrap+=<
let c_comment_strings=1
set lazyredraw
set modeline
set scrolloff=3
set sidescrolloff=7
set sidescroll=1
"set guifont=Courier\ New:h12:cRUSSIAN
set confirm
set shortmess=fimnrxoOtTI
set ruler
" ringbell
set novisualbell
set t_vb=
set vb t_vb=
" show unfinished commands in statusbar
set showcmd
set cursorline
"norm \[i
" display current mode
"set showmode
set noshowmode
set noerrorbells
"set nocp " option for cppomnicomplete
set list
set listchars=tab:>·,trail:·,precedes:#,extends:#,nbsp:·

" allow to use backspace instead of "x"
set backspace=indent,eol,start whichwrap+=<,>,[,]
" do not abandon buffer when it is unloaded
set hidden
" mouse
set mousemodel=popup
set mouse=a
set mousehide
" Fix <Enter> for comment
set fo+=cr
" buffers for autocomplete
set complete=""
set complete+=.
set complete+=k
set complete+=b
set complete+=t

set wildmenu
set wcm=<Tab>
"dont fold by default
set nofoldenable
" tags
set tags+=tags
set tags+=tags2

" vim-ruby
if has("unix")
  set runtimepath+=~/.vim/vim-ruby
  set runtimepath+=~/.vim/vim-rails
endif
"-----------------------------------------------------------------------------
" hotkeys
"-----------------------------------------------------------------------------
vmap < <gv
vmap > >gv

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <c-c> "+y
vnoremap <c-insert> "+y

" CTRL-V and SHIFT-Insert are Paste
"map <c-v>     "+gP
map <s-insert>    "+gP

"cmap <c-v>    <c-r>+
cmap <s-insert>   <c-r>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

"imap <s-insert> <c-v>
"vmap <s-insert> <c-v>

nmap <a-v> <c-v>
vmap <a-v> <c-v>
"imap <c-v> <space><esc>"+gP<del>i
" movement
vmap <c-k> 10k
nmap <c-k> 10k
vmap <c-j> 10j
nmap <c-j> 10j
" up
nmap k gk
vmap k gk
imap <c-k> <up>
cmap <c-k> <up>
" down
nmap j gj
vmap j gj
imap <c-j> <down>
cmap <c-j> <down>
" left
nmap h <left>
vmap h <left>
imap <c-h> <left>
imap <c-b> <left>
imap <c-f> <righT>
cmap <c-h> <left>
" right
nmap l <right>
vmap l <right>
imap <c-l> <right>
cmap <c-l> <right>
" ESC button
imap jj <Esc><right>
" arrows
nmap <down> gj
nmap <up> gk
vmap <down> gj
vmap <up> gk
imap <down> <c-O>gj
imap <up> <c-O>gk
" save position while page up/down
nmap <pageup> <c-U><c-U>
nmap <pagedown> <c-D><c-D>
imap <pageup> <c-O><c-U><c-O><c-U>
imap <pagedown> <c-O><c-D><c-O><c-D>
vmap <pageup> <c-U><c-U>
vmap <pagedown> <c-D><c-D>
" CamelCase movement
map <silent> w <plug>CamelCaseMotion_w
map <silent> b <plug>CamelCaseMotion_b
map <silent> e <plug>CamelCaseMotion_e
" Bubble single lines
nmap <c-up> [e
nmap <c-down> ]e
" Bubble multiple lines
vmap <c-up> [egv
vmap <c-down> ]egv
" move with shift
imap <s-k4> <esc>Bi
vmap <s-k4> B
nmap <s-k4> B
imap <s-k6> <esc>Ea
vmap <s-k6> E
nmap <s-k6> E
map <s-k8> <pageup>
map <s-k2> <pagedown>
" set ctrl+c to behave like esc
inoremap <c-c> <esc>
" insert newline after current line
nmap <silent> <cr> o<Esc>
" insert newline before current line
nmap <silent> <s-cr> O<Esc>
" turn off highlighting and clear messages
nmap <silent> <space> :nohlsearch<Bar>:echo<cr>
" autocomplete
imap <tab> <c-r>=InsertTabWordWrapper()<cr>
imap <c-tab> <c-r>=InsertTabLineWrapper()<cr>
imap <s-tab> <c-n>
" quit
nmap <c-q> :q!<cr>
vmap <c-q> <esc>:q!<cr>i
imap <c-q> <esc>:q!<cr>i

nmap <silent><a-S-left> :tabmove -1<cr>
imap <silent><a-S-left> <c-O>:tabmove -1<cr>
nmap <silent><a-S-right> :tabmove +1<cr>
imap <silent><a-S-right> <c-O>:tabmove +1<cr>
" search selected text
vmap <silent>* <esc>:call VisualSearch('/')<cr>/<c-R>/<cr>
vmap <silent># <esc>:call VisualSearch('?')<cr>?<c-R>/<cr>
" Trailing Spaces
nmap <silent>,t :call RemoveTrailingSpaces()<cr>:echo 'trailing spaces have been removed'<cr>

nmap gs <c-w><c-v><c-w>l:A<cr>
" Git
nnoremap <f5> :Gcommit<cr>
inoremap <f5> <c-O>:Gcommit<cr>
vnoremap <f5> <esc>:Gcommit<cr>

nnoremap <f6> :Gdiff<cr>
inoremap <f6> <c-O>:Gdiff<cr>
vnoremap <f6> <esc>:Gdiff<cr>
" Tags
"nnoremap <f10> :TagbarToggle<cr>
"inoremap <f10> <c-O>:TagbarToggle<cr>
"vnoremap <f10> <esc>:TagbarToggle<cr>
"nnoremap <f12> :emenu Tags.<tab>
"inoremap <f12> <c-O>:emenu Tags.<tab>
"vnoremap <f12> <esc>:emenu Tags.<tab>
" ruby debugger
" vimrc edit
if exists('$MYGVIMRC')
  map ,v :vsp $MYGVIMRC<CR>
  map ,V :source $MYGVIMRC<CR>
else
  map ,v :vsp $MYVIMRC<CR>
  map ,V :source $MYVIMRC<CR>
end

imap {<cr> {<cr>}<Esc>O
imap <% <%  %><left><left><left>
imap <%= <%= %><left><left><left>

" 'Control + \' - Open a new tab and tag into the function/variable currently under cursor
"map <c-\> :tab split<cr>:exec("tag ".expand("<cword>"))<cr>
" NERDCommenter
map ,<space> <plug>NERDCommenterToggle

" чтобы не копировать выделенный текст в дефолтный регистр при вставке
vnoremap p "_dp
"-----------------------------------------------------------------------------
" menu
"-----------------------------------------------------------------------------
if !has("unix")
  anoremenu &File.&Font.&Monaco_10 :set guifont=Monaco:h10<cr>
  anoremenu &File.&Font.&Consolas_10 :set guifont=Consolas:h12:cRUSSIAN<cr>
  anoremenu &File.&Font.&Monaco_12 :set guifont=Monaco:h10<cr>
  anoremenu &File.&Font.&Monaco_12_russian :set guifont=Monaco:h12:cRUSSIAN<cr>
endif

anoremenu &File.&EOL.&unix :setlocal fileformat=unix<cr>
anoremenu &File.&EOL.&dos :setlocal fileformat=dos<cr>
anoremenu &File.&EOL.&mac :setlocal fileformat=mac<cr>

anoremenu &File.E&ncoding.&Write.&utf-8 :setlocal fileencoding=utf-8<cr>
anoremenu &File.E&ncoding.&Write.&windows-1251 :setlocal fileencoding=windows-1251<cr>
anoremenu &File.E&ncoding.&Write.&iso-8859-15 :setlocal fileencoding=iso-8859-15<cr>
anoremenu &File.E&ncoding.&Write.&koi8-r :setlocal fileencoding=koi8-r<cr>

anoremenu &File.E&ncoding.&Read.&utf-8 :edit ++enc=utf-8<cr>
anoremenu &File.E&ncoding.&Read.&windows-1251 :edit ++enc=windows-1251<cr>
anoremenu &File.E&ncoding.&Read.&iso-8859-15 :edit ++enc=iso-8859-15<cr>
anoremenu &File.E&ncoding.&Read.&koi8-r :edit ++enc=koi8-r<cr>

anoremenu &File.&Spell.&Combined :setlocal spell spelllang=ru,en<cr>
anoremenu &File.&Spell.&Russian :setlocal spell spelllang=ru<cr>
anoremenu &File.&Spell.&English :setlocal spell spelllang=en<cr>
anoremenu &File.&Spell.&Off :setlocal nospell spelllang=<cr>

"-----------------------------------------------------------------------------
" autocommands
"-----------------------------------------------------------------------------
" syntax highlight fix for brackets
au BufNewFile,BufRead *.rb syn match rubyParens "[()\[\]{}]"

" backups
autocmd! bufwritepre * call BackupDir()
" reload vimrc
if has("unix")
  autocmd! bufwritepost ~/.vimrc source ~/.vimrc
  autocmd! bufwritepost ~/.gvimrc source ~/.gvimrc

  autocmd! bufwritepost ~/.vim/vimrc source ~/.vim/vimrc
  autocmd! bufwritepost ~/.vim/gvimrc source ~/.vim/gvimrc
else
  autocmd! bufwritepost ~/vimfiles/gvimrc source ~/vimfiles/gvimrc
  autocmd! bufwritepost ~/vimfiles/vimrc source ~/vimfiles/vimrc
  autocmd! bufwritepost $VIM/_gvimrc source $VIM/_gvimrc
  autocmd! bufwritepost $VIM/_vimrc source $VIM/_vimrc
endif

au BufRead,BufNewFile *.scss set filetype=scss
au BufNewFile,BufRead *.json set filetype=javascript
au BufNewFile,BufRead *.slim set filetype=slim
au BufNewFile,BufRead *.json set filetype=json
au BufNewFile,BufRead *.jade.erb set filetype=pug

"au BufNewFile,BufRead *.rb set makeprg=ruby\ -c\ %
au BufNewFile,BufRead *.ass,*.ssa set filetype=ssa
"-----------------------------------------------------------------------------
" omni completion
"-----------------------------------------------------------------------------
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=RjsComplete
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
"-----------------------------------------------------------------------------
" functions
"-----------------------------------------------------------------------------
function! VisualSearch(cmd)
  let l:old_reg=getreg('"')
  let l:old_regtype=getregtype('"')
  normal! gvy
  let @/='\V'.substitute(substitute(substitute(escape(@@, a:cmd.'\'), '^\_s\+', '\\s\\+', ''), '\_s\+$', '\\s\\*', ''), '\_s\+', '\\_s\\+', 'g')
  normal! gV
  call setreg('"', l:old_reg, l:old_regtype)
endfunction

function! RemoveTrailingSpaces()
  normal! mzHmy
  execute '%s/\t/  /ge'
  execute '%s/\s\+$//ge'
  normal! 'yzt`z
endfunction

function! BackupDir()
  if has("win32")
    let l:backupdir=$HOME.'\.backup\'.substitute(expand('%:p:h'), ':', '', '')
  else
    let l:backupdir=substitute($HOME.'/.backup/'.substitute(expand('%:p:h'), ':', '', ''), '//', '/', '')
  endif

  if !isdirectory(l:backupdir)
    call mkdir(l:backupdir, 'p', 0700)
  endif

  let &backupdir=l:backupdir

  if has("win32")
    let &backupext=strftime('~%Y-%m-%d %H_%M_%S~')
  else
    let &backupext=strftime('~%Y-%m-%d %H:%M:%S~')
  endif
endfunction

function! InsertTabWordWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

function! InsertTabLineWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-x>\<c-l>"
  endif
endfunction

"visual search mappings
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

"-----------------------------------------------------------------------------
" plugins
"-----------------------------------------------------------------------------
" ruby code completion
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_include_object = 1
let g:rubycomplete_include_objectspace = 1
let g:rubycomplete_rails = 1

" Matchit
"let b:match_words = '<:>,<tag>:</tag>'
" SessionMgr
let g:SessionMgr_AutoManage = 0
let g:SessionMgr_DefaultName = "last"
" Tlist settings
"let g:Tlist_Show_One_File = 1
"let g:Tlist_GainFocus_On_ToggleOpen = 1
"let g:Tlist_Use_Right_Window = 1
"let g:Tlist_WinWidth = 45

set completeopt-=preview
set completeopt+=longest

" used to make vim default 'man' viewer
" see http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
let $PAGER=''
