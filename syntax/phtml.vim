" Vim syntax file
" Language:     PHP Templates (Solarphp, PHPSavant etc...)
" Maintainer:   Giuliani Sanches (giulianit at gmail dot com)
" URL:          http://giulianisanches.blogspot.com
" Last Change:  2007 Novembro 20
" Version:	0.1.2
"
" ###################################################################################################
" Based on Armin Ronacher mako.vim syntax file (http://www.vim.org/scripts/script.php?script_id=1858)
" ###################################################################################################
"
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = "html"
endif

"Source the html syntax file
ru! syntax/html.vim
unlet b:current_syntax

"Put the php syntax file in @phpTop
syn include @phpTop syntax/php_phtml.vim

" Block rules
syn region phpBlock start=#<?# end=#?># keepend contains=@phpTop

hi phpConstant_     guifg=#99CC99     guibg=gray20      gui=bold      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpCoreConstant_ guifg=#99CC99     guibg=gray20      gui=bold      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpComment_      guifg=#7F9F7F     guibg=gray20      gui=italic    ctermfg=darkgray    ctermbg=NONE        cterm=NONE
hi phpException_    guifg=#6699CC     guibg=gray20      gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE
hi phpBoolean_      guifg=#99CC99     guibg=gray20      gui=bold      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpStorageClass_ guifg=#FFFFB6     guibg=gray20      gui=NONE      ctermfg=yellow      ctermbg=NONE        cterm=NONE
hi phpSCKeyword_    guifg=#FFFFB6     guibg=gray20      gui=NONE      ctermfg=yellow      ctermbg=NONE        cterm=NONE
hi phpFCKeyword_    guifg=#96CBFE     guibg=gray20      gui=NONE      ctermfg=blue        ctermbg=NONE        cterm=NONE
hi phpStructure_    guifg=#FFFFB6     guibg=gray20      gui=NONE      ctermfg=yellow      ctermbg=NONE        cterm=NONE
hi phpStringSingle_ guifg=#FFA0A0     guibg=gray20      gui=NONE      ctermfg=green       ctermbg=NONE        cterm=NONE
hi phpStringDouble_ guifg=#FFA0A0     guibg=gray20      gui=NONE      ctermfg=green       ctermbg=NONE        cterm=NONE
hi phpBacktick_     guifg=#FFA0A0     guibg=gray20      gui=NONE      ctermfg=green       ctermbg=NONE        cterm=NONE
hi phpNumber_       guifg=#FF73FD     guibg=gray20      gui=NONE      ctermfg=magenta     ctermbg=NONE        cterm=NONE
hi phpFloat_        guifg=#FF73FD     guibg=gray20      gui=NONE      ctermfg=magenta     ctermbg=NONE        cterm=NONE
hi phpMethods_      guifg=#FFD2A7     guibg=gray20      gui=NONE      ctermfg=brown       ctermbg=NONE        cterm=NONE
hi phpFunctions_    guifg=#FFD2A7     guibg=gray20      gui=NONE      ctermfg=brown       ctermbg=NONE        cterm=NONE
hi phpBaselib_      guifg=#FFD2A7     guibg=gray20      gui=NONE      ctermfg=brown       ctermbg=NONE        cterm=NONE
hi phpRepeat_       guifg=#6699CC     guibg=gray20      gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE
hi phpConditional_  guifg=#6699CC     guibg=gray20      gui=NONE      ctermfg=blue        ctermbg=NONE        cterm=NONE
hi phpLabel_        guifg=#6699CC     guibg=gray20      gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE
hi phpStatement_    guifg=#6699CC     guibg=gray20      gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE
hi phpKeyword_      guifg=#6699CC     guibg=gray20      gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE
hi phpType_         guifg=#FFFFB6     guibg=gray20      gui=NONE      ctermfg=yellow      ctermbg=NONE        cterm=NONE
hi phpInclude_      guifg=#96CBFE     guibg=gray20      gui=NONE      ctermfg=blue        ctermbg=NONE        cterm=NONE
hi phpDefine_       guifg=#96CBFE     guibg=gray20      gui=NONE      ctermfg=blue        ctermbg=NONE        cterm=NONE
hi phpSpecialChar_  guifg=#E18964     guibg=gray20      gui=NONE      ctermfg=white       ctermbg=NONE        cterm=NONE
hi phpParent_       guifg=#DCDCCC     guibg=gray20      gui=NONE      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpIdentifierConst_ guifg=#DCDCCC  guibg=gray20      gui=NONE      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpMemberSelector_ guifg=#FFFFB6   guibg=gray20      gui=NONE      ctermfg=yellow      ctermbg=NONE        cterm=NONE
hi phpIntVar_       guifg=#C6C5FE     guibg=gray20      gui=NONE      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpEnvVar_       guifg=#C6C5FE     guibg=gray20      gui=NONE      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpOperator_     guifg=white       guibg=gray20      gui=NONE      ctermfg=white       ctermbg=NONE        cterm=NONE
hi phpVarSelector_  guifg=white       guibg=gray20      gui=NONE      ctermfg=white       ctermbg=NONE        cterm=NONE
hi phpRelation_     guifg=white       guibg=gray20      gui=NONE      ctermfg=white       ctermbg=NONE        cterm=NONE
hi phpIdentifier_   guifg=#C6C5FE     guibg=gray20      gui=NONE      ctermfg=cyan        ctermbg=NONE        cterm=NONE
hi phpIdentifierSimply_ guifg=#C6C5FE guibg=gray20      gui=NONE      ctermfg=cyan        ctermbg=NONE        cterm=NONE

" Default highlighting links
if version >= 508 || !exists("did_php_syn_inits")
  if version < 508
    let did_php_syn_inits = 1
    com -nargs=+ HiLink hi link <args>
  else
    com -nargs=+ HiLink hi def link <args>
  endif

  delc HiLink
endif

let b:current_syntax = "html"
