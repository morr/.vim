"-----------------------------------------------------------------------------
" specky
"-----------------------------------------------------------------------------
let g:speckyBannerKey        = "rb"
"let g:speckyQuoteSwitcherKey = "r'"
let g:speckyRunRdocKey       = "rd"
let g:speckySpecSwitcherKey  = "gs"
let g:speckyRunSpecKey       = "rs"
"let g:speckyRunRdocCmd       = "fri -L -f plain"
let g:speckyWindowType       = 2

"-----------------------------------------------------------------------------
" pathogen
"-----------------------------------------------------------------------------
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype on
