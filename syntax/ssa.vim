" Vim syntax file
" Language:          SSA (Sub Station Alpha)
" Maintainer:        Don Yang <omoikane@uguu.org>
" Latest Revision:   2004-05-06


if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif
if !exists("main_syntax")
   let main_syntax = "ssa"
endif


syn match ssaSection       "^\[.*\]"
syn match ssaSourceComment "^;.*$"
syn match ssaLine          "^[^;][^:]*:.*$"  contains=ssaHeader,ssaComment,ssaDialog

syn match ssaHeader        "^[^;][^:]*:\s*"  contained nextgroup=ssaHeaderText
syn match ssaHeaderText    ".*$"             contained

syn match ssaComment       "^Comment:\s*"    contained nextgroup=ssaCommentText
syn match ssaCommentText   ".*$"             contained

syn match ssaDialog        "^Dialogue:\s*"   contained nextgroup=ssaDialogTimes
syn match ssaDialogTimes   "\([^,]*,\)\{4}"  contained nextgroup=ssaDialogActor
syn match ssaDialogActor   "[^,]*"           contained nextgroup=ssaDialogEffects
syn match ssaDialogEffects ",\([^,]*,\)\{4}" contained nextgroup=ssaDialogText
syn match ssaDialogText    ".*$"             contained contains=ssaTextComment,ssaTextSubCode

syn match ssaTextComment   "{[^}]*}"         contained
syn match ssaTextSubCode   "{\\[^}]*}"       contained


hi link ssaSection         Directory
hi link ssaSourceComment   Directory

hi link ssaHeader          Label
hi link ssaComment         Label
hi link ssaDialog          Label

hi link ssaHeaderText      Constant
hi link ssaCommentText     Comment
hi link ssaDialogTimes     Comment
hi link ssaDialogActor     Title
hi link ssaDialogEffects   Comment
hi link ssaDialogText      Normal

hi link ssaTextComment     Comment
hi link ssaTextSubCode     Identifier


let b:current_syntax = "ssa"
if main_syntax == "ssa"
   unlet main_syntax
endif
