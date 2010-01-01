" Lynx www browser control
"
" Copyright (c) 2004 John Connors <johnc@yagc.ndo.co.uk>
" All rights reserved.
"
" Redistribution and use, with or without modification, are permitted
" provided that the following conditions are met:
"
" 1. Redistributions must retain the above copyright notice, this list
"    of conditions and the following disclaimer.
"
" 2. The name of the author may not be used to endorse or promote
"    products derived from this script without specific prior written
"    permission.
"
" THIS SCRIPT IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
" OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
" INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
" HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
" STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
" IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
" POSSIBILITY OF SUCH DAMAGE.
" 
if exists("loaded_lynxbrowser")
    finish
endif
let loaded_lynxbrowser = 1

"
" define the command we use to drive lynx
"
let s:lynxCmd = 'lynx -dump'
let s:referencePattern = 'file:[^#]*'
let s:partlinkMatch = '[0-9]*\]'
let s:linkMatch = '\[[0-9]*\]'
let s:referenceMatchPrefix = ' *'
let s:referenceMatchPostfix = '\. file:[^#]*'
let s:lynxIndex = -1 
let s:lynxBufferNumber = -1

fun! s:LynxExec(file)
	" set buffer name and command
	let cmd = s:lynxCmd . " '" . a:file . "' 2>/dev/null"

	exe "setlocal modifiable"
	" handle shell redirection portable
	if $OS !~? 'Windows'
	    let save_shell = &shell
	    set shell=/bin/sh
	endif
	let save_shellredir = &shellredir
    	set shellredir=>
	exe "silent 0,$!".cmd
	let &shellredir = save_shellredir
	if $OS !~? 'Windows'
	    let &shell = save_shell
	endif
	exe "setlocal nomodifiable"
	exe "setlocal buftype=nowrite"
endfun

"
" Assumes there is a lynx style link in the buffer under the cursor and
" attemps to follow it
"
fun! s:LynxFollowLink()
	" look it up
	let v:errmsg = ""

	" remember our location
	
	let lynx_line = line('.')
	let lynx_col = virtcol('.')
	let lynx_start_line = getline('.')
	call s:LynxMarkLink(lynx_col, lynx_line, lynx_start_line)

	let linkurl = matchstr(lynx_start_line, s:referencePattern)
	" ok we didn't find an url under the cursor, we have a number and have to
	if linkurl == ''
		let linknum = matchstr(lynx_start_line, s:partlinkMatch)
		if linknum == ''
			let linknum = matchstr(lynx_start_line, s:linkMatch)
			if linknum == ''
				let v:errmsg = "Cannot follow link. Cursor not on link."
			else
				let linknum = strpart(linknum, 1, strlen(linknum) - 2)
			endif
		else
			let linknum = strpart(linknum, 0, strlen(linknum)-1)
		endif
		"
		" link num should now contain a valid link number
		" (if it doesnt we need to handle it..at present random stuff happens)
		" 
		let refPattern = s:referenceMatchPrefix . linknum . s:referenceMatchPostfix
		let refLine = search(refPattern, 'W')
		if refLine == 0
			let v:errmsg = "Cannot follow link. Cannot find reference."
		else
			let reference_line = getline('.')
			let linkurl = matchstr(reference_line, s:referencePattern)
		endif
	endif
	" strip file://localhost
	if linkurl != ''
		let linkfile = strpart(linkurl, 16) 
		call s:LynxExec(linkfile)
		let lynx_line = line('.')
		let lynx_col = virtcol('.')
		let lynx_start_line = getline('.')
		call s:LynxPushLink(linkfile, lynx_col, lynx_line, lynx_start_line)
	else 
		call s:LynxPopLink()
	endif
   if (v:errmsg != "")
	  echo v:errmsg
	endif
endfun

fun! s:LynxLink(file)
	call s:LynxBufferInit()
	call s:LynxExec(a:file)
	call s:LynxPushLink(a:file, virtcol("."), line("."), getline("."))
endfun

fun! s:LynxMarkLink(lcol, lline, lstartline)
  let s:lynx_col_{s:lynxIndex} = a:lcol
  let s:lynx_lin_{s:lynxIndex} = a:lline
  let s:lynx_startline_{s:lynxIndex} = a:lstartline
endfun

fun! s:LynxPushLink(linkfile, lcol, lline, lstartline)
  let s:lynxIndex = s:lynxIndex + 1 
  let s:lynx_col_{s:lynxIndex} = a:lcol
  let s:lynx_lin_{s:lynxIndex} = a:lline
  let s:lynx_file_{s:lynxIndex} = a:linkfile
  let s:lynx_startline_{s:lynxIndex} = a:lstartline
endfun

fun! s:LynxBacktrackLink()
  if s:lynxIndex != 0
	  let s:lynxIndex = s:lynxIndex - 1 
  endif
  call s:LynxExec(s:lynx_file_{s:lynxIndex})
  execute s:lynx_lin_{s:lynxIndex}
  execute "normal!" s:lynx_col_{s:lynxIndex} . "|"
  let stLine = s:lynx_startline_{s:lynxIndex}
  if getline('.') !=# stLine
    if ! search('\V\^'.escape(stLine, "\\").'\$', 'W') 
      call search('\V\^'.escape(stLine, "\\").'\$', 'bW')
    endif
  endif
  echo stLine
endfun

fun! s:LynxPopLink()
  if s:lynxIndex != 0
	  let s:lynxIndex = s:lynxIndex - 1 
  endif
endfun

fun! s:LynxBufferInit()
	"
	" if the lynx buffer exists, 
	"
	if bufexists(s:lynxBufferNumber)
		exe "sbuffer " . s:lynxBufferNumber	
	else
		exe "new"
		let s:lynxBufferNumber = bufnr("%")
		exe "setlocal buftype=nowrite"
		exe "setlocal bufhidden=delete"
		exe "setlocal nomodifiable"
	endif	

	" remove all insert mode abbreviations
	iabc <buffer>

	" add our own mappings
    noremap <buffer> <CR>	:call <SID>LynxFollowLink()<cr>
    noremap <buffer> <C-]>	:call <SID>LynxFollowLink()<cr>
	noremap <buffer> <C-T>  :call <SID>LynxBacktrackLink()<cr>

endfun!

command! -complete=file -nargs=1 Lynx call s:LynxLink(<f-args>)
command! -nargs=0 LynxFollowLink call s:LynxFollowLink()
command! -nargs=0 LynxBacktrackLink call s:LynxBacktrackLink()

