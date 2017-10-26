"-----------------------------------------------------------------------------
" hotkeys
"-----------------------------------------------------------------------------
vmap < <gv
vmap > >gv

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
" vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <c-c> "+y
" vnoremap <c-insert> "+y

" CTRL-V and SHIFT-Insert are Paste
"map <c-v>     "+gP
" map <s-insert>    "+gP

"cmap <c-v>    <c-r>+
" cmap <s-insert>   <c-r>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

"imap <s-insert> <c-v>
"vmap <s-insert> <c-v>

" nmap <a-v> <c-v>
" vmap <a-v> <c-v>
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
" nmap <c-up> [e
" nmap <c-down> ]e
" Bubble multiple lines
" vmap <c-up> [egv
" vmap <c-down> ]egv
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
" quit
nmap <c-q> :q!<cr>
vmap <c-q> <esc>:q!<cr>i
imap <c-q> <esc>:q!<cr>i

" Tags
"nnoremap <f10> :TagbarToggle<cr>
"inoremap <f10> <c-O>:TagbarToggle<cr>
"vnoremap <f10> <esc>:TagbarToggle<cr>
"nnoremap <f12> :emenu Tags.<tab>
"inoremap <f12> <c-O>:emenu Tags.<tab>
"vnoremap <f12> <esc>:emenu Tags.<tab>
" ruby debugger
" vimrc edit


" imap {<cr> {<cr>}<Esc>O
" imap <% <%  %><left><left><left>
" imap <%= <%= %><left><left><left>

" 'Control + \' - Open a new tab and tag into the function/variable currently under cursor
"map <c-\> :tab split<cr>:exec("tag ".expand("<cword>"))<cr>

" чтобы не копировать выделенный текст в дефолтный регистр при вставке
vnoremap p "_dp

nnoremap <f12> :bd<cr>

"-----------------------------------------------------------------------------
" open vim config
"-----------------------------------------------------------------------------
map ,v :e ~/.vim/vimrc<CR>

"-----------------------------------------------------------------------------
" autocomplete
"-----------------------------------------------------------------------------
" imap <tab> <c-r>=InsertTabWordWrapper()<cr>
" imap <c-tab> <c-r>=InsertTabLineWrapper()<cr>
" imap <s-tab> <c-n>

" function! InsertTabWordWrapper()
  " let col = col('.') - 1
  " if !col || getline('.')[col - 1] !~ '\k'
    " return "\<tab>"
  " else
    " return "\<c-p>"
  " endif
" endfunction

" function! InsertTabLineWrapper()
  " let col = col('.') - 1
  " if !col || getline('.')[col - 1] !~ '\k'
    " return "\<tab>"
  " else
    " return "\<c-x>\<c-l>"
  " endif
" endfunction

"-----------------------------------------------------------------------------
" VisualSearch
" search selected text
"-----------------------------------------------------------------------------
" vmap <silent>* <esc>:call VisualSearch('/')<cr>/<c-R>/<cr>
" vmap <silent># <esc>:call VisualSearch('?')<cr>?<c-R>/<cr>

" function! VisualSearch(cmd)
  " let l:old_reg=getreg('"')
  " let l:old_regtype=getregtype('"')
  " normal! gvy
  " let @/='\V'.substitute(substitute(substitute(escape(@@, a:cmd.'\'), '^\_s\+', '\\s\\+', ''), '\_s\+$', '\\s\\*', ''), '\_s\+', '\\_s\\+', 'g')
  " normal! gV
  " call setreg('"', l:old_reg, l:old_regtype)
" endfunction

" vmap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
" vmap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" "visual search mappings
" function! s:VSetSearch()
  " let temp = @@
  " norm! gvy
  " let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  " let @@ = temp
" endfunction

"-----------------------------------------------------------------------------
" RemoveTrailingSpaces
"-----------------------------------------------------------------------------
nmap <silent>,t :call RemoveTrailingSpaces()<cr>:echo 'trailing spaces have been removed'<cr>

function! RemoveTrailingSpaces()
  normal! mzHmy
  execute '%s/\t/  /ge'
  execute '%s/\s\+$//ge'
  normal! 'yzt`z
endfunction

"-----------------------------------------------------------------------------
" tabmove
"-----------------------------------------------------------------------------
nmap <silent><a-S-left> :tabmove -1<cr>
imap <silent><a-S-left> <c-O>:tabmove -1<cr>
nmap <silent><a-S-right> :tabmove +1<cr>
imap <silent><a-S-right> <c-O>:tabmove +1<cr>

"-----------------------------------------------------------------------------
" switch and remember colorschemes
"-----------------------------------------------------------------------------
map <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>"

" nmap <f8> :colors ir_black_morr<cr>
" nmap <f9> :colors papercolor<cr>:set background=dark<cr>
" nmap <f10> :colors papercolor<cr>:set background=light<cr>
" nmap <f11> :colors solarized<cr>:set background=dark<cr>
" nmap <f12> :colors solarized<cr>:set background=light<cr>

nmap ,cd1 :call <SID>InstallColor("colors solarized\\nset background=dark")<cr>
nmap ,cd2 :call <SID>InstallColor("colors papercolor\\nset background=dark")<cr>
nmap ,cd3 :call <SID>InstallColor("colors one\\nset background=dark\\nlet g:airline_theme='one'")<cr>
nmap ,cd4 :call <SID>InstallColor("colors ir_black_morr")<cr>
nmap ,cd5 :call <SID>InstallColor("colors vim-material\\nlet g:airline_theme='material'")<cr>
nmap ,cd6 :call <SID>InstallColor("colors spring-night\\nlet g:airline_theme='spring_night'")<cr>

nmap ,cl1 :call <SID>InstallColor("colors solarized\\nset background=light")<cr>
nmap ,cl2 :call <SID>InstallColor("colors papercolor\\nset background=light")<cr>
nmap ,cl3 :call <SID>InstallColor("colors one\\nset background=light\\nlet g:airline_theme='one'")<cr>

nmap ,c01 :call <SID>InstallColor("colors sialoquent")<cr>
nmap ,c02 :call <SID>InstallColor("colors SerialExperimentsLain")<cr>
nmap ,c04 :call <SID>InstallColor("colors basic-dark")<cr>
nmap ,c04 :call <SID>InstallColor("colors basic-light")<cr>
nmap ,c05 :call <SID>InstallColor("colors smyck")<cr>
nmap ,c06 :call <SID>InstallColor("colors carbonized-light")<cr>
nmap ,c07 :call <SID>InstallColor("colors carbonized-dark")<cr>
nmap ,c08 :call <SID>InstallColor("colors macvim-light")<cr>
nmap ,c11 :call <SID>InstallColor("colors greygull")<cr>
nmap ,c12 :call <SID>InstallColor("colors petrel")<cr>
nmap ,c13 :call <SID>InstallColor("colors seagull")<cr>
nmap ,c14 :call <SID>InstallColor("colors stormpetrel")<cr>

function! s:InstallColor(cmd)
  echo split(a:cmd, "\\")[0]
  silent exe "!echo \"".a:cmd."\" > $HOME/.vim/colorscheme.vim"
  source $HOME/.vim/colorscheme.vim
endfunction
