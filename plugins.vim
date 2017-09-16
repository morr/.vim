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
let g:CommandTWildIgnore = &wildignore."*.o,*.obj,.git,.svn,*.log,public/assets/**,public/uploads/**,public/packs/**,public/system/**,public/images/**,tmp/cache/**,tmp/miniprofiler/**,tmp/sass-cache/**,tmp/pages/**,tmp/cache/**,test/pages/**,spec/pages/**,node_modules/**"

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
let g:ag_search_ignore = 'log,public,tmp,spec/vcr_cassettes,node_modules'
let g:ag_prg="ag --nogroup --nocolor --column "
let g:ag_qhandler="copen 12"
" map <Leader>/ <esc>:call AgSearch()<cr>

" function! AgSearch()
  " let l:search_phrase=input('Ag ')
  " redraw
  " echo "Ack Searching..."
  " silent execute ':Ag --ignore-dir={'.g:ag_search_ignore.'} '.l:search_phrase
" endfunction

map <Leader>/ :call <SID>MyLAg()<CR>

" `!` is not allowed in function name
function! s:MyLAg()
  let l:search_phrase = input(':LAg! ')
  redraw
  echo 'Searching...'

  " don't use `silent` - or else no message
  " will be shown when no matches are found
  "
  " https://github.com/mileszs/ack.vim/issues/5
  " https://stackoverflow.com/a/15403852/3632318
  " https://stackoverflow.com/questions/5669194
  " :help escape()
  " :help shellescape()
  "
  " WHY SUCH A COMPLICATED COMBINATION?
  "
  " for `LAg!` to work we need to:
  "
  " - not to escape `!` at all
  " - escape `%#` twice
  " - escape other special characters (slashes, etc.) once
  "
  " - `shellescape({string})`
  "   escapes all special characters once (excluding `!%#`)
  " - `shellescape({string}, 1)`
  "   escapes all special characters once (including `!%#`)
  " - `escape({string}, {chars})`
  "   escapes only the characters it's told to escape
  "
  " => escape all special characters with `shellescape` once
  "   (excluding `!%#`) and escape `%#` with `escape` twice
  exec ':LAg! ' . escape(escape(shellescape(l:search_phrase), '%#'), '%#')
endfunction

"-----------------------------------------------------------------------------
" syntastic
"-----------------------------------------------------------------------------
"let g:syntastic_ruby_checkers=['mri'] ", 'rubylint', 'rubocop'
"let g:syntastic_ruby_mri_args='-T1 -c'
let g:syntastic_json_checkers=['jsonlint', 'jslint'] " npm install -g jsonlint
let g:syntastic_coffee_checkers=['coffeelint']
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
"
" example projections: https://gist.github.com/henrik/5676109
"-------------------------------------------------------------------------------
nmap <F4> :A<CR>
nmap <Leader><F4> :AV<CR>

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

"-----------------------------------------------------------------------------
" colorschemes
"-----------------------------------------------------------------------------
map <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>"

nmap <f8> :colors ir_black_morr<cr>
nmap <f9> :colors papercolor<cr>:set background=dark<cr>
nmap <f10> :colors papercolor<cr>:set background=light<cr>
nmap <f11> :colors solarized<cr>:set background=dark<cr>
nmap <f12> :colors solarized<cr>:set background=light<cr>

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
