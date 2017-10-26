"-----------------------------------------------------------------------------
" supertab
"-----------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = '<C-n>'

"-----------------------------------------------------------------------------
" matchit
"-----------------------------------------------------------------------------
runtime macros/matchit.vim

"-----------------------------------------------------------------------------
" powerline
"-----------------------------------------------------------------------------
set laststatus=2
let g:airline_powerline_fonts = 1

let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#whitespace#enabled = 0

let g:airline#extensions#tabline#enabled = 0
" let g:airline#extensions#tabline#formatter = 'default'
" let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline#extensions#tabline#show_buffers = 0

" disable airline integration with https://github.com/airblade/vim-gitgutter
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#hunks#non_zero_only = 1

"-----------------------------------------------------------------------------
" buffergator
"-----------------------------------------------------------------------------
let g:buffergator_suppress_keymaps = 1
nnoremap <silent> <Leader>b :BuffergatorToggle<CR>

"-----------------------------------------------------------------------------
" Command-T
"-----------------------------------------------------------------------------
let g:CommandTMaxHeight = 17
" let g:CommandTMaxFiles = 25000
let g:CommandTWildIgnore = &wildignore.".git,log,tmp,node_modules,*/public/assets,*/public/uploads,*/public/packs,*/public/packs-test,*/public/system,*/public/images,*/spec/vcr_cassettes"
let g:CommandTFileScanner = 'git'
let g:CommandTTraverseSC = 'pwd'
" let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTMatchWindowReverse = 0
let g:CommandTMatchWindowAtTop = 0
let g:CommandTGitIncludeUntracked = 1

let g:CommandTAcceptSelectionCommand = 'e'
let g:CommandTAcceptSelectionTabCommand = 'tabe'
let g:CommandTAcceptSelectionSplitCommand = 'sp'
let g:CommandTAcceptSelectionVSplitCommand = 'vs'

" nmap <silent> <leader>t :tabe<cr>:CommandT<cr>
" nmap <silent> <leader>t :call <SID>SmartCommandT()<cr>
nmap <silent> <leader>r :CommandTFlush<cr>:CommandT<cr>
" nmap <silent> <leader>j :CommandTJump<CR>

nmap <f1> :CommandT<cr>

function! s:SmartCommandT()
  if bufname("%") == ""
    CommandT
  else
    tabe
    CommandT
  end
endfunction

" буферы закрываем всегда
" function! s:set_bufhidden()
  " if empty(&buftype)
    " setlocal bufhidden=wipe
  " endif
" endfunction

" autocmd! BufRead * call s:set_bufhidden()


"-----------------------------------------------------------------------------
" LustyExplorer
"-----------------------------------------------------------------------------
nmap <silent> <leader>l :LustyBufferGrep<cr>
" nmap <f4> :LustyBufferGrep<cr>

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
map ,<space> <plug>NERDCommenterToggle


"-----------------------------------------------------------------------------
" fugitive
"-----------------------------------------------------------------------------
" nnoremap <f5> :Gcommit<cr>
" inoremap <f5> <c-O>:Gcommit<cr>
" vnoremap <f5> <esc>:Gcommit<cr>

nnoremap <f6> :Gdiff<cr>
inoremap <f6> <c-O>:Gdiff<cr>
vnoremap <f6> <esc>:Gdiff<cr>


"-----------------------------------------------------------------------------
" EasyMotion
"-----------------------------------------------------------------------------
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_do_mapping = 0

map ; <Plug>(easymotion-s)
"map <c-;> <Plug>(easymotion-repeat)


"-----------------------------------------------------------------------------
" Ag
"-----------------------------------------------------------------------------
let g:ag_search_ignore = 'log,public,tmp,spec/vcr_cassettes,node_modules'
let g:ag_prg="ag --nogroup --nocolor --column "
let g:ag_qhandler="copen 12"
" map <Leader>/ <esc>:call AgSearch()<cr>

nmap <F5> :Ag! 
"-----------------------------------------------------------------------------
" syntastic
"-----------------------------------------------------------------------------
"let g:syntastic_ruby_checkers=['mri'] ", 'rubylint', 'rubocop'
"let g:syntastic_ruby_mri_args='-T1 -c'
let g:syntastic_json_checkers=['jsonlint', 'jslint'] " npm install -g jsonlint
let g:syntastic_coffee_checkers=['coffeelint']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'npm run lint --'

let g:syntastic_slim_checkers=[]
let g:syntastic_ruby_checkers=[]
let g:syntastic_sass_checkers=[]

let g:vim_json_syntax_conceal = 0
" let g:syntastic_ruby_mri_exec = 'ruby2.3.1'
" let g:syntastic_ruby_mri_quiet_messages = {
" \ 'regex': [
" \   '\m`&'' interpreted as argument prefix',
" \   '\m`*'' interpreted as argument prefix'
" \ ] }
"\   '\m^shadowing outer local variable',
"let g:syntastic_enable_signs=1
"let g:syntastic_auto_loc_list=1
nnoremap <silent> ,r :SyntasticCheck ruby rubocop<CR>
nnoremap <silent> ,R :w<cr>:silent !rubocop --auto-correct %<cr>:edit!<cr>


"-------------------------------------------------------------------------------
" vim-rails
"-------------------------------------------------------------------------------
nmap <F4> :A<CR>
nmap <Leader><F4> :AV<CR>
nmap gs :AV<cr>

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
\     'alternate': 'config/locales/{}zh-CN.yml'
\   },
\   'config/locales/*zh-CN.yml': {
\     'alternate': 'config/locales/{}ru.yml'
\   }
\ }

"-------------------------------------------------------------------------------
" ack.vim
"
" rg respects ./.gitignore and ~/.ignore files
"-------------------------------------------------------------------------------

let g:ackprg = 'rg --fixed-strings --smart-case --vimgrep'
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
" ruby code completion
"-----------------------------------------------------------------------------
" let g:rubycomplete_buffer_loading = 1
" let g:rubycomplete_classes_in_global = 1
" let g:rubycomplete_include_object = 1
" let g:rubycomplete_include_objectspace = 1
" let g:rubycomplete_rails = 1

"-----------------------------------------------------------------------------
" Matchit
"-----------------------------------------------------------------------------
"let b:match_words = '<:>,<tag>:</tag>'

"-----------------------------------------------------------------------------
" vim-repeat
"-----------------------------------------------------------------------------
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"-----------------------------------------------------------------------------
" SessionMgr
"-----------------------------------------------------------------------------
let g:SessionMgr_AutoManage = 0
let g:SessionMgr_DefaultName = "last"

"-----------------------------------------------------------------------------
" Tlist settings
"-----------------------------------------------------------------------------
"let g:Tlist_Show_One_File = 1
"let g:Tlist_GainFocus_On_ToggleOpen = 1
"let g:Tlist_Use_Right_Window = 1
"let g:Tlist_WinWidth = 45

"-------------------------------------------------------------------------------
" QFEnter
"
" QFEnter respects `switchbuf` option! if selected file is opened
" in another tab all mappings below just switch to that tab
"-------------------------------------------------------------------------------

" disable automatic opening of quickfix window (or location list)
" when opening file from current quickfix window in a new tab
let g:qfenter_enable_autoquickfix = 0

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>']
let g:qfenter_keymap.open_keep = ['<S-CR>']
let g:qfenter_keymap.hopen = ['<C-s>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.topen = ['<C-t>']"
