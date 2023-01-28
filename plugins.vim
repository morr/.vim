call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'bkad/CamelCaseMotion'
Plug 'briancollins/vim-jst'
Plug 'cakebaker/scss-syntax.vim'
Plug 'digitaltoad/vim-pug'
Plug 'elixir-lang/vim-elixir'
Plug 'elzr/vim-json'
Plug 'flazz/vim-colorschemes'
Plug 'henrik/vim-indexed-search'
Plug 'int3/vim-extradite'
Plug 'vim-scripts/matchit.zip'
Plug 'mhinz/vim-hugefile'
Plug 'slim-template/vim-slim'
Plug 'sstephenson/eco'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'morr/vim-ruby'
Plug 'vim-scripts/grep.vim'
Plug 'jparise/vim-graphql'
Plug 'keithbsmiley/rspec.vim'

"-----------------------------------------------------------------------------
" javascript
"-----------------------------------------------------------------------------
Plug 'morr/vim-javascript'
Plug 'mxw/vim-jsx'

"-----------------------------------------------------------------------------
" styles
"-----------------------------------------------------------------------------

Plug 'aunsira/macvim-light'
Plug 'davidklsn/vim-sialoquent'
Plug 'dim13/smyck.vim'
Plug 'hzchirs/vim-material'
Plug 'hzchirs/vim-material'
Plug 'lu-ren/SerialExperimentsLain'
Plug 'mom0tomo/dotfiles'
Plug 'nightsense/carbonized'
Plug 'nightsense/seabird'
Plug 'rakr/vim-one'
Plug 'rhysd/vim-color-spring-night'
Plug 'tomasr/molokai'
Plug 'zcodes/vim-colors-basic'

"-----------------------------------------------------------------------------
Plug 'posva/vim-vue'
"-----------------------------------------------------------------------------
au BufNewFile,BufRead *.vue setf vue
" https://github.com/posva/vim-vue#how-to-use-commenting-functionality-with-multiple-languages-in-vue-files
au FileType vue syntax sync fromstart

" Vim slows down when using this plugin How can I fix that?
let g:vue_pre_processors = ['pug', 'sass']

"-----------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
"-----------------------------------------------------------------------------
autocmd User fugitive
  \ if get(b:, 'fugitive_type', '') =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete
set diffopt+=vertical

" nnoremap <f5> :Gcommit<cr>
" inoremap <f5> <c-O>:Gcommit<cr>
" vnoremap <f5> <esc>:Gcommit<cr>

nnoremap <f6> :Gdiff<cr>
inoremap <f6> <c-O>:Gdiff<cr>
vnoremap <f6> <esc>:Gdiff<cr>

"-----------------------------------------------------------------------------
Plug 'ervandew/supertab'
"-----------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = '<C-n>'

"-----------------------------------------------------------------------------
Plug 'jeetsukumaran/vim-buffergator'
"-----------------------------------------------------------------------------
let g:buffergator_suppress_keymaps = 1
nnoremap <silent> <Leader>b :BuffergatorToggle<CR>

"-----------------------------------------------------------------------------
Plug '/opt/homebrew/opt/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"-----------------------------------------------------------------------------
nmap <leader>t :Files<cr>
nmap <leader>r :Rg<cr>
nmap <leader>b :Buffers<cr>

" Nord theme https://github.com/junegunn/fzf/wiki/Color-schemes#nord 
let color_scheme_options = 'fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C,pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B'
let $BAT_THEME='Nord'
" https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf
let $FZF_DEFAULT_OPTS = '--layout=reverse --color='.color_scheme_options
let $FZF_DEFAULT_COMMAND = 'fd --type file --hidden --follow --ignore-file .gitignore -E .git -E node_modules -E tmp'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

" [Buffers] Do not Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" default rip grep search behaviour but with hidden files included
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --hidden --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

"-----------------------------------------------------------------------------
Plug 'scrooloose/nerdtree'
"-----------------------------------------------------------------------------
map <silent> <leader>n :NERDTreeToggle<cr>
map <silent> <leader>N :NERDTreeFind<cr>
nmap <f2> :NERDTreeFind<cr>
nmap <f3> :NERDTreeToggle<cr>

let g:NERDTreeIgnore = ['node_modules']

"-----------------------------------------------------------------------------
" replacement for nerdcommenter that works for vue
Plug 'tyru/caw.vim'
Plug 'Shougo/context_filetype.vim'
"-----------------------------------------------------------------------------
map ,<space> <plug>(caw:hatpos:toggle)

"-----------------------------------------------------------------------------
Plug 'dense-analysis/ale'
"-----------------------------------------------------------------------------
" only linters from g:ale_linters are enabled
let g:ale_linters_explicit = 1

" hi ALEWarningSign guibg=#FDE1FD guifg=#0512FB gui=bold
" hi ALEErrorSign guibg=#F4DBDC guifg=#662529 gui=bold

" location list is populated by default -
" this might overwrite the contents of already
" opened location list (e.g., search results)
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

let g:ale_sign_warning = 'W>'
let g:ale_sign_error = 'E>'

let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1

" virtual-text is broken when it displayed in wrapped state
let g:ale_virtualtext_cursor = 0

let g:ale_linters = {
\   'elixir': ['credo'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'ruby': ['rubocop']
\ }

au BufNewFile,BufRead *.rb nnoremap <silent> ,R :w<cr>:silent !rubocop --auto-correct %<cr>:edit!<cr>
au BufNewFile,BufRead *.js nnoremap <silent> ,R :w<cr>:silent !yarn run eslint --fix %<cr>:edit!<cr>
au BufNewFile,BufRead *.jsx nnoremap <silent> ,R :w<cr>:silent !yarn run eslint --fix %<cr>:edit!<cr>
au BufNewFile,BufRead *.vue nnoremap <silent> ,R :w<cr>:silent !yarn run eslint --fix %<cr>:edit!<cr>

"-------------------------------------------------------------------------------
Plug 'tpope/vim-rails'
"-------------------------------------------------------------------------------
nmap <F4> :A<CR>
nmap <Leader><F4> :AV<CR>
nmap gs :AV<cr>
nmap gS :A<cr>

" example projections: https://gist.github.com/henrik/5676109
let g:rails_projections = {
\   'app/*.rb': {
\     'alternate': 'spec/{}_spec.rb'
\   },
\   'app/admin/*.rb': {
\     'alternate': 'spec/controllers/admin/{}_controller_spec.rb'
\   },
\   'spec/controllers/admin/*_controller_spec.rb': {
\     'alternate': 'app/admin/{}.rb'
\   },
\   'config/locales/*ru.yml': {
\     'alternate': 'config/locales/{}en.yml'
\   },
\   'config/locales/*en.yml': {
\     'alternate': 'config/locales/{}ru.yml'
\   }
\ }

"-------------------------------------------------------------------------------
Plug 'tap349/ack.vim'
"-------------------------------------------------------------------------------

let g:ackprg = 'rg --fixed-strings --smart-case --ignore-file $HOME/.agignore --vimgrep'
" disable empty search (searching the word under cursor) -
" it complicates the logic to parse user input excessively
"
" use <C-r><C-w> to paste the word under cursor
let g:ack_use_cword_for_empty_search = 0

" QFEnter works with both quickfix windows and location lists
map <Leader>/ :call <SID>Search()<CR>
map <Leader>\ :call <SID>SearchWithGlob()<CR>

function! s:Search()
  echohl AckSearch
  let l:input_phrase = input('⎸SEARCH > ')
  echohl None

  call <SID>MyLAck(l:input_phrase, '')
endfunction

function! s:SearchWithGlob()
  echohl AckSearch
  let l:input_phrase = input('⎸SEARCH [1/2] > ')
  redraw!
  let l:glob = input('⎸GLOB [2/2] > ')
  echohl None

  call <SID>MyLAck(l:input_phrase, l:glob)
endfunction

" `!` is not allowed in function name
"
" https://github.com/mileszs/ack.vim/issues/5
" https://stackoverflow.com/a/15403852/3632318
" https://stackoverflow.com/questions/5669194
" :help escape()
" :help shellescape()
"
" for rg to work we need:
"
" - not to escape `!` at all
" - to escape `%#` twice
" - to escape other special characters (slashes, etc.) once
" - not to treat strings starting with dashes as rg options
"
" useful functions:
"
" - `shellescape({string})`:
"   escapes all special characters once (excluding `!%#`)
" - `shellescape({string}, 1)`:
"   escapes all special characters once (including `!%#`)
" - `escape({string}, {chars})`:
"   escapes only the characters it's told to escape
" - `--` (options delimiter):
"   signifies the end of rg options
"
" => escape all special characters excluding `!%#` with
"    `shellescape`, escape `%#` with `escape` twice
"    and let `--` deal with strings starting with dashes
function! s:MyLAck(input_phrase, ...)
  let l:glob = get(a:, 1, '')
  let l:glob_option = len(l:glob) ? '-g ''*' . l:glob . '*''' : ''

  let l:delimiter = ' -- '
  let l:split_args = split(a:input_phrase, l:delimiter)
  let l:args_len = len(l:split_args)

  " no arguments
  if l:args_len == 0
    call <SID>ShowWarningMessage('Empty search')
    return
  " options only (`-w -- `)
  elseif l:args_len == 1 && a:input_phrase =~ l:delimiter . '$'
    call <SID>ShowWarningMessage('Empty search')
    return
  " search phrase only (` -- foo` or `foo`)
  elseif l:args_len == 1
    let l:options = l:glob_option
    let l:search_phrase = join(l:split_args)
  " options and search phrase
  else
    let l:options = l:glob_option . ' ' . l:split_args[0]
    let l:search_phrase = join(l:split_args[1:-1], l:delimiter)
  endif

  " ack.vim already escapes `|%#` once in autoload/ack.vim -
  " escape `%#` once again here so that they're escaped twice
  let l:escaped_search_phrase = escape(shellescape(l:search_phrase), '%#')

  " don't use `silent` - it suppresses 'no match found' message
  "
  " search might break if ' -- ' is a substring of search phrase
  " and user doesn't provide options - then part of search phrase
  " is parsed as options which might yield unpredictable results
  exec ':LAck! ' . l:options . l:delimiter . l:escaped_search_phrase
endfunction

function! s:ShowWarningMessage(message)
  redraw!
  echohl WarningMsg
  echo a:message
  echohl None
endfunction

"-----------------------------------------------------------------------------
Plug 'tpope/vim-repeat'
"-----------------------------------------------------------------------------
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"-------------------------------------------------------------------------------
Plug 'tap349/QFEnter'
" QFEnter respects `switchbuf` option! if selected file is opened
" in another tab all mappings below just switch to that tab
"-------------------------------------------------------------------------------

" disable automatic opening of quickfix window (or location list)
" when opening file from current quickfix window in a new tab
let g:qfenter_enable_autoquickfix = 0

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<C-CR>']
let g:qfenter_keymap.open_keep = ['<S-CR>']
let g:qfenter_keymap.open_close = ['<CR>']
let g:qfenter_keymap.hopen = ['<C-s>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.topen = ['<C-t>']


"-----------------------------------------------------------------------------
Plug 'osyo-manga/vim-anzu'
"-----------------------------------------------------------------------------
nmap * <Plug>(anzu-star)
nmap # <Plug>(anzu-sharp)
nmap n <Plug>(anzu-mode-n)
nmap N <Plug>(anzu-mode-N)

"-----------------------------------------------------------------------------
" Plug 'haya14busa/vim-asterisk'
"-----------------------------------------------------------------------------
" map *   <Plug>(asterisk-*)
" map #   <Plug>(asterisk-#)
" map g*  <Plug>(asterisk-g*)
" map g#  <Plug>(asterisk-g#)
" map z*  <Plug>(asterisk-z*)
" map gz* <Plug>(asterisk-gz*)
" map z#  <Plug>(asterisk-z#)
" map gz# <Plug>(asterisk-gz#)

" Initialize plugin system
call plug#end()
