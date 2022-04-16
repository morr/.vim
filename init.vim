"-----------------------------------------------------------------------------
" config files
"-----------------------------------------------------------------------------
source ~/.vim/plugins.vim
source ~/.vim/mappings.vim
source ~/.vim/colorscheme.vim

"-----------------------------------------------------------------------------
" editing
"-----------------------------------------------------------------------------
set cpoptions+=$
set colorcolumn=81
" do not highlight after 200 column
set synmaxcol=200

" http://vim.wikia.com/wiki/Project_specific_settings
function! SetupEnvironment()
  let l:path = expand('%:p')
  if l:path =~ '/Users/morr/develop/shikimori/'
    setlocal colorcolumn=101
  endif
endfunction
autocmd! BufReadPost,BufNewFile * call SetupEnvironment()

"-----------------------------------------------------------------------------
" other options
"-----------------------------------------------------------------------------
set nocompatible
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
" split
set splitright    " to open slits with 'gs' in right split
" gui
syntax on
set t_Co=256
"colors ir_black_morr
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

set maxmempattern=100000 " to avoid errors when opening huge VCR cassete files

set nobackup

" vim-ruby
if has("unix")
  set runtimepath+=~/.vim/vim-ruby
  set runtimepath+=~/.vim/vim-rails
endif

"-----------------------------------------------------------------------------
" autocommands
"-----------------------------------------------------------------------------
" syntax highlight fix for brackets
" au BufNewFile,BufRead *.rb syn match rubyParens "[()\[\]{}]"
" au BufNewFile,BufRead *.json syn match rubyParens "[()\[\]{}]"
" au BufNewFile,BufRead *.js syn match rubyParens "[()\[\]{}]"
" au BufNewFile,BufRead *.coffee syn match rubyParens "[()\[\]{}]"
" au BufNewFile,BufRead *.jbuilder syn match rubyParens "[()\[\]{}]"

autocmd! bufwritepost ~/.vim/vimrc source ~/.vim/vimrc
autocmd! bufwritepost ~/.vim/colorscheme.vim source ~/.vim/colorscheme.vim
autocmd! bufwritepost ~/.vim/plugins.vim source ~/.vim/plugins.vim
autocmd! bufwritepost ~/.vim/mappings.vim source ~/.vim/mappings.vim

au BufRead,BufNewFile *.scss set filetype=scss
au BufNewFile,BufRead *.json set filetype=javascript
au BufNewFile,BufRead *.slim set filetype=slim
au BufNewFile,BufRead *.json set filetype=json
au BufNewFile,BufRead *.jade.erb set filetype=pug

"au BufNewFile,BufRead *.rb set makeprg=ruby\ -c\ %
au BufNewFile,BufRead *.ass,*.ssa set filetype=ssa

"-----------------------------------------------------------------------------
" functions
"-----------------------------------------------------------------------------
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

set completeopt-=preview
set completeopt+=longest

