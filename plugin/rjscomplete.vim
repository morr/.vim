" Vim plugin with javascript omnicompletion
" Maintainer: Andrey Sidorov <takandar@gmail.com>
" Last Change: 2010 Dec 12

if exists("g:loaded_rjscomplete") || &cp || v:version < 700
  finish
endif
"let g:loaded_rjscomplete = 1

if !exists('g:rjscomplete_library')
  let g:rjscomplete_library = ''
endif

" do not enable this option, it is bugged
if !exists('g:rjscomplete_show_path')
  let g:rjscomplete_show_path = '0'
endif

if !exists('g:rjscomplete_find_in_prototype')
  let g:rjscomplete_find_in_prototype = '0'
endif

let s:closures = {}

function! DrawRjsMenu()
  exec "anoremenu &Javascript.&none :call SetRjsCompleteLibarary('')<cr>"
  let files = split(globpath(&rtp, 'javascript/libs/*'), '\n')
  if len(files) > 0
    for file in files
      if filereadable(file."/tags")
        if has("unix")
          let filename = substitute(file, "^.*javascript/libs/", "", "")
        else
          let filename = substitute(file, "^.*javascript\\\\libs\\", "", "")
        end
        exec "anoremenu &Javascript.&".escape(filename, " .")." :call SetRjsCompleteLibarary('".filename."')<cr>"
      endif
    endfor
  endif
endfunction


function! SetRjsCompleteLibarary(library)
  if g:rjscomplete_library != ''
    exec("set tags-=~/.vimdata/javascript/libs/".escape(g:rjscomplete_library, " ")."/tags")
  end
  if a:library != ''
    exec("set tags+=~/.vimdata/javascript/libs/".escape(a:library, " ")."/tags")
  end
  let g:rjscomplete_library = a:library
endfunction


function! RjsComplete(findstart, base)
  let s:base = a:base

  " Main function {{{
  if a:findstart
    return s:FindStart()
  else
    let s:properties = []
    let s:methods = []

    let s:last_reduced_object = {'name': '', 'prefix': '', 'type': ''}

    call s:CompleteWord(a:base, 0)
    unlet! b:compl_context

    return filter(extend(s:properties, s:methods), 'v:val.word =~? "^'.s:base.'"')
    "list ret = []
    "for hash in s:properties
      "if hash.word =~? '^'.s:base
        "call add(ret, hash)
      "endif
    "endfor
    "for hash in s:methods
      "if hash.word =~? '^'.s:base
        "call add(ret, hash)
      "endif
    "endfor
    "return ret
  endif
  " }}}
endfunction


function! s:FindStart()
  " locate the start of the word
  let line = getline('.')
  let start = col('.') - 1
  let curline = line('.')
  let compl_begin = col('.') - 2
  " Bit risky but JS is rather limited language and local chars shouldn't
  " fint way into names
  while start >= 0 && line[start - 1] =~ '\k'
    let start -= 1
  endwhile
  let b:compl_context = getline('.')[0:compl_begin]
  return start
endfunction


function! s:CompleteWord(base, prototype)
  let s:shortcontext = substitute(b:compl_context, a:base.'$', '', '')

  let object = {}
  let object_type = 'undefined'
  if s:shortcontext !~ '\.$'
    let object.name = a:base
    let object.prefix = ''
    let object.type = 'window'
    call s:TagsGlobals(object)
    call s:GetBuildInTypeProperties(object)
  else
    " jQuery block
    if g:rjscomplete_library =~ 'jQuery'
      let s:shortcontext = substitute(s:shortcontext, '\<$\>', 'jQuery', '')
      if match(s:shortcontext, '(.*)[') != -1
        let object_type = 'DOMElement'
      elseif match(s:shortcontext, '^jQuery(.*)') != -1
        let s:shortcontext = "jQuery.fn."
      end
    end

    let object.name = matchstr(s:shortcontext, '\zs\k\+\ze\(\[.\{-}\]\)\?\.$')
    let object.prefix = substitute(substitute(substitute(s:shortcontext, '\.$', '', ''), object.name.'$', '', ''), '\.$', '' ,'')
    let object.type = object_type

    if object.type == 'undefined'
      "call s:BuffersResolve(object)
      if object.type == 'undefined'
        let object = s:TagsResolve(object, 1)
      endif
    endif

    "echoe 'name:'.object.name.', prefix:'.object.prefix.', type:'.object.type
    if object.type == 'undefined'
      call s:TagsMembers(object)
    endif
    let s:properties = sort(s:properties, "s:PropCompare")
    let s:methods = sort(s:methods, "s:PropCompare")

    if !a:prototype
      if g:rjscomplete_find_in_prototype
        let b:compl_context = b:compl_context.'prototype.'
        call s:CompleteWord(a:base, 1)
      end
      call s:GetBuildInTypeProperties(object)
    end
  endif
endfunction


function! s:Tag2Item(object, field)
    let hash = {}
    let hash.word = substitute(a:field.text, '^\([^\t]\+\)\t.*$', '\1', '')
    if match(hash.word, '\.') != -1 || match(hash.word, '^CLOSURE_\d\+') != -1
      return {}
    end
    let hash.kind = substitute(a:field.text, '^.*\tkind:\%([^:.\t]\+\%(::\|\.\)\)*\([^:.\t]\+\)\t.*$', '\1', '')
    let hash.kind = substitute(hash.kind, 'CLOSURE_\d\+', 'Function', '')

    if g:rjscomplete_show_path
      let hash.menu = substitute(a:object.prefix.'.'.a:object.name, '^\.', '', '')
      " resolve CLOSURES in hash.menu
      while match(hash.menu, 'CLOSURE_\d\+') != -1
        let closure = substitute(hash.menu, '.*\(CLOSURE_\d\+\).*', '\1', '')
        if !has_key(s:closures, closure)
          let s:closures[closure] = s:TagsClosureName(closure)
        end
        let hash.menu = substitute(hash.menu, 'CLOSURE_\d\+', s:closures[closure] != "" ? s:closures[closure] : "", "")
      endwhile
    end

    return hash
endfunction


function! s:TagsClosureName(closure)
  " Finds closure name in tags {{{
  let fnames = join(map(tagfiles(), 'escape(v:val, " #%")'))
  if fnames != ''
    exe 'silent! vimgrep /\(::\|\.\|\)\?'.a:closure.'\tscope:\t.*/j '.fnames
    let qflist = getqflist()
    if len(qflist) > 0
      for field in qflist
        return substitute(field.text, '\t.*', '', '')
      endfor
    endif
  endif
  return ""
  " }}}
endfunction


function! s:TagsGlobals(object)
  " Finds global objects in tags {{{
  let fnames = join(map(tagfiles(), 'escape(v:val, " #%")'))

  if fnames != ''
    exe 'silent! vimgrep /^'.escape(a:object.name, "$").'.*\tscope:\t.*/j '.fnames
    let qflist = getqflist()
    if len(qflist) > 0
      for field in qflist
        let hash = s:Tag2Item(a:object, field)

        if hash != {} "&& hash.word =~? '^'.s:base
          if hash.kind == 'Function'
            call add(s:methods, hash)
          else
            call add(s:properties, hash)
          endif
        endif
      endfor
    endif
  endif
  return a:object
  " }}}
endfunction


function! s:TagsType(object)
  " Finds object type in tags {{{
  for tag in taglist('^'.a:object.name.'$')
    if match(tag.cmd, 'scope:\%(::\|\.\|\)'.escape(a:object.prefix, "$").'\t.*language:js') != -1
      return substitute(tag.cmd, '^.*\tkind:\([^\t]\+\)\tscope:\%(::\|\.\|\)'.escape(a:object.prefix, "$").'\t.*$', '\1', '')
    endif
  endfor
  return 'undefined'

  "let object_type = 'undefined'
  "let fnames = join(map(tagfiles(), 'escape(v:val, " #%")'))
  "if fnames != ''
    "exe 'silent! vimgrep /^'.escape(a:object.name, "$").'\t.*\tscope:\(::\|\.\|\)'.escape(a:object.prefix, "$").'\t.*language:js$/j '.fnames
    "let qflist = getqflist()
    "if len(qflist) > 0
      "for field in qflist
        "let object_type = substitute(field.text, '^.*\tkind:\([^\t]\+\)\tscope:\%(::\|\.\|\)'.escape(a:object.prefix, "$").'\t.*$', '\1', '')
        "break
      "endfor
    "endif
  "endif
  "return object_type
  " }}}
endfunction


function! s:TagsMembers(object)
  " Finds object members in tags {{{
  let fnames = join(map(tagfiles(), 'escape(v:val, " #%")'))

  if fnames != ''
    "echoe 'silent! vimgrep /\tscope:\(::\|\.\|\)'.escape(a:object.prefix.".".a:object.name, "$").'\t/j '.fnames
    exe 'silent! vimgrep /\tscope:\(::\|\.\|\)'.escape(a:object.prefix.".".a:object.name, "$").'\t/j '.fnames
    let qflist = getqflist()
    if len(qflist) > 0
      for field in qflist
        let hash = s:Tag2Item(a:object, field)

        if hash != {}
        "&& hash.word =~? '^'.s:base
          if hash.kind == 'Function'
            call add(s:methods, hash)
          else
            call add(s:properties, hash)
          endif
        endif
      endfor
    endif
  endif
  return a:object
  " }}}
endfunction


function! s:TagsResolve(object, add_properties)
  " Find object type declaration in tags {{{
  let a:object.type = s:TagsType(a:object)
  "echoe 'name:'.a:object.name.', prefix:'.a:object.prefix.', type:'.a:object.type

  " if object's type contains :: or . lets check if its type is buildin
  "if match(a:object.type, '\w\+::\w\+') != -1
    "let tmp_type = substitute(a:object.type, '^.*::\(\w\+\)$', '\1', '')
    "if s:IsBuildInType(tmp_type)
      "let a:object.type = tmp_type
    "endif
  "endif

  " if object is not found but its prefix is not empty then lets try to reduce prefix
  if a:object.type == 'undefined' && a:object.prefix != ''
    let reduced_object = {}
    let reduced_object.name = substitute(a:object.prefix, '^\%(.*\%(\.\|::\)\)\?\(\w\+\)$', '\1', '')
    let reduced_object.prefix = substitute(a:object.prefix, '\%(\.\|::\)\?'.escape(reduced_object.name, '$').'$', '', '')
    let reduced_object.type = 'undefined'

    let reduced_object_original_name = reduced_object.name
    if s:last_reduced_object.name != reduced_object.name || s:last_reduced_object.prefix != reduced_object.prefix || s:last_reduced_object.type != reduced_object.type
      "echoe 'reduced_object try name:'.reduced_object.name.', prefix:'.reduced_object.prefix.', type:'.reduced_object.type
      let s:last_reduced_object.name = reduced_object.name
      let s:last_reduced_object.prefix = reduced_object.prefix
      let s:last_reduced_object.type = reduced_object.type
      let reduced_object = s:TagsResolve(reduced_object, 0)
    end
    "echoe 'reduced_object original_name:'.reduced_object_original_name.', name:'.reduced_object.name.', prefix:'.reduced_object.prefix.', type:'.reduced_object.type
    if reduced_object.type != 'undefined'
      if a:add_properties
        call s:TagsMembers(a:object)
      end
      " add resolved name to s:closures dictionary
      let s:closures[reduced_object.name] = reduced_object_original_name
      "echoe 'prior object name:'.a:object.name.', prefix:'.a:object.prefix.', type:'.a:object.type
      let a:object.prefix = substitute(substitute(a:object.prefix, '.*'.reduced_object_original_name.'\%(\.\|$\)', reduced_object.prefix.'.'.reduced_object.name.'.', ''), '\.$', '' ,'')
      "echoe 'return_object_after_reduce name:'.a:object.name.', prefix:'.a:object.prefix.', type:'.a:object.type
      return s:TagsResolve(a:object, a:add_properties)
    end
  endif

  " if object is found but its type is not buildin type then lets try to replace it
  if a:object.type != 'undefined' && !s:IsBuildInType(a:object.type)
    let replaced_object = {}
    let replaced_object.name = substitute(a:object.type, '^.*\%(\.\|::\)\(\w\+\)$', '\1', '')
    let replaced_object.prefix = substitute(a:object.type, '\%(\.\|::\)\?'.replaced_object.name.'$', '', '')
    let replaced_object.type = 'undefined'

    if s:TagsType(replaced_object) != a:object.type
      if a:add_properties
        call s:TagsMembers(a:object)
      end
      "echoe 'return_replaced_object name:'.replaced_object.name.', prefix:'.replaced_object.prefix.', type:'.replaced_object.type
      return s:TagsResolve(replaced_object, a:add_properties)
    end
  end

  if a:add_properties
    call s:TagsMembers(a:object)
  end
  "echoe 'return_object name:'.a:object.name.', prefix:'.a:object.prefix.', type:'.a:object.type
  return a:object
  " }}}
endfunction


function! s:BuffersResolve(object)
  " Find object type declaration in open buffers. {{{
  " 1. Get object name
  " 2. Find object declaration line
  " 3. General declaration follows "= new Type" syntax, additional else
  "    for regexp "= /re/"
  " 4. Make correction for Microsoft.XMLHTTP ActiveXObject
  " 5. Repeat for external files
  let a:object.type = 'undefined'
  if len(a:object.name) > 0
    let decl_line = search(a:object.name.'.\{-}=\s*new\s*', 'bn')
    if decl_line > 0
      let a:object.type = matchstr(getline(decl_line), a:object.name.'.\{-}=\s*new\s*\zs\k\+\ze')
      if a:object.type == 'ActiveXObject' && matchstr(getline(decl_line), a:object.name.'.\{-}=\s*new\s*ActiveXObject\s*(.Microsoft\.XMLHTTP.)') != ''
          let a:object.type = 'XMLHttpRequest'
      endif
    else
      let pos = getpos('.')
      let sstr = '^\s*var\s*'.a:object.name.'\s*=\s*'
      let fstr = '[\|{\|''\|"\|function\|\/'
      let [lnum,lcol] = searchpos(sstr,'nb',1)
      if lnum != 0 && lcol != 0
        let str = matchstr(getline(lnum),fstr,lcol)
        if str == '"' || str == ''''
          let a:object.type = 'String'
        elseif str == '['
          let a:object.type = 'Array'
        elseif str == '{'
          let a:object.type = 'Hash'
        elseif str == '/'
          let a:object.type = 'RegExp'
        elseif str == 'function'
          let a:object.type = 'Function'
        endif
      endif
    endif
    " We didn't find var declaration in current file but we may have
    " something in external files.
    if decl_line == 0 && exists("b:js_extfiles")
      let dext_line = filter(copy(b:js_extfiles), 'v:val =~ "'.a:object.name.'.\\{-}=\\s*new\\s*"')
      if len(dext_line) > 0
        let a:object.type = matchstr(dext_line[-1], a:object.name.'.\{-}=\s*new\s*\zs\k\+\ze')
        if a:object.type == 'ActiveXObject' && matchstr(dext_line[-1], a:object.name.'.\{-}=\s*new\s*ActiveXObject\s*(.Microsoft\.XMLHTTP.)') != ''
            let a:object.type = 'XMLHttpRequest'
        endif
      else
        let dext_line = filter(copy(b:js_extfiles), 'v:val =~ "var\s*'.a:object.name.'\\s*=\\s*\\/"')
        if len(dext_line) > 0
          let a:object.type = 'RegExp'
        endif
      endif
    endif
  endif

  return a:object
  " }}}
endfunction


function! s:IsBuildInType(type)
  if a:type == 'Object'
    return 1
  elseif a:type == 'Function'
    return 1
  elseif a:type == 'Date'
    return 1
  elseif a:type == 'Image'
    return 1
  elseif a:type == 'Array'
    return 1
  elseif a:type == 'Boolean'
    return 1
  elseif a:type == 'XMLHttpRequest'
    return 1
  elseif a:type == 'String'
    return 1
  elseif a:type == 'RegExp'
    return 1
  elseif a:type == 'Math'
    return 1
  elseif a:type == 'DOMElement'
    return 1
  endif
  return 0
endfunction


function! s:PropCompare(a, b)
  return tolower(a:a.word) == tolower(a:b.word) ? 0 : tolower(a:a.word) > tolower(a:b.word) ? 1 : -1
endfunction


function! s:MakeProperties(type, properties, methods)
  let data = []

  for v in a:properties
    call add(data, {'word': v, 'kind': 'Property', 'menu': g:rjscomplete_show_path ? a:type.'.Prototype' : ""})
  endfor
  for v in a:methods
    call add(data, {'word': v, 'kind': 'Function', 'menu': g:rjscomplete_show_path ? a:type.'.Prototype' : ""})
  endfor

  return data
endfunction


function! s:GetBuildInTypeProperties(object)
  let object = {'name': a:object.name, 'prefix': a:object.prefix, 'type': a:object.type}
  if object.type == 'undefined'
    let object.type = object.name
  end
  " {{{ Complete methods and properties for default objects
  if object.type == 'Object'
    let values = s:objes
  elseif object.type == 'Function'
    let values = s:funcs
  elseif object.type == 'Number'
    let values = s:numbs
  elseif object.type == 'Date'
    let values = s:dates
  "elseif object.type == 'Image'
    "let values = s:imags
  elseif object.type == 'Array'
    let values = s:arrays
  elseif object.type == 'Boolean'
    let values = s:bools
  "elseif object.type == 'XMLHttpRequest'
    "let values = s:xmlhs
  elseif object.type == 'String'
    let values = s:stris
  elseif object.type == 'RegExp'
    let values = s:reges
  elseif object.type == 'Math'
    let values = s:maths
  elseif object.type == 'DOMElement'
    let values = s:xdomelems
  elseif object.type == 'window'
    let values = s:winds
  endif

  if !exists('values')
    " List of properties
    if s:shortcontext =~ 'Math\.$'
      let values = s:maths
    "elseif s:shortcontext =~ 'anchors\(\[.\{-}\]\)\?\.$'
      "let values = s:anths
    "elseif s:shortcontext =~ 'area\.$'
      "let values = s:areas
    "elseif s:shortcontext =~ 'base\.$'
      "let values = s:bases
    "elseif s:shortcontext =~ 'body\.$'
      "let values = s:bodys
    elseif s:shortcontext =~ 'document\.$'
      let values = s:docus
    "elseif s:shortcontext =~ 'forms\(\[.\{-}\]\)\?\.$'
      "let values = s:forms
    "elseif s:shortcontext =~ 'frameset\.$'
      "let values = s:fsets
    elseif s:shortcontext =~ 'history\.$'
      let values = s:hists
    "elseif s:shortcontext =~ 'iframe\.$'
      "let values = s:ifras
    "elseif s:shortcontext =~ 'images\(\[.\{-}\]\)\?\.$'
      "let values = s:imags
    "elseif s:shortcontext =~ 'links\(\[.\{-}\]\)\?\.$'
      "let values = s:links
    elseif s:shortcontext =~ 'location\.$'
      let values = s:locas
    "elseif s:shortcontext =~ 'meta\.$'
      "let values = s:metas
    elseif s:shortcontext =~ 'navigator\.$'
      let values = s:navis
    elseif s:shortcontext =~ 'object\.$'
      let values = s:objes
    "elseif s:shortcontext =~ 'screen\.$'
      "let values = s:scres
    "elseif s:shortcontext =~ 'style\.$'
      "let values = s:styls
    "elseif s:shortcontext =~ 'table\.$'
      "let values = s:tabls
    "elseif s:shortcontext =~ 'TableData\.$'
      "let values = s:tdats
    "elseif s:shortcontext =~ 'TableRow\.$'
      "let values = s:trows
    elseif s:shortcontext =~ 'window\.$'
      let values = s:winds
    "elseif s:shortcontext =~ 'parseError\.$'
      "let values = s:xdomerror
    "elseif s:shortcontext =~ 'attributes\[\d\+\]\.$'
      "let values = s:xdomattrprop
    elseif s:shortcontext =~ 'arguments\.$'
      let values = s:args
    else
      let values = []
      "let values = objes
    endif
  endif

  for hash in values
    if hash.kind == 'Function'
      call add(s:methods, hash)
    else
      call add(s:properties, hash)
    endif
  endfor
" }}}
endfunction

" {{{ methods and properties for default objects
" Arrays
let arrayprop = ['constructor', 'index', 'input', 'length', 'prototype']
let arraymeth = ['concat', 'join', 'pop', 'push', 'reverse', 'shift', 'slice', 'splice', 'sort', 'toSource', 'toString', 'unshift', 'valueOf',  'watch', 'unwatch']
let s:arrays = s:MakeProperties('Array', arrayprop, arraymeth)

" Boolean - complete subset of array values
let boolprop = ['constructor', 'prototype']
let boolmeth = ['toSource', 'toString', 'valueOf']
let s:bools = s:MakeProperties('Boolean', boolprop, boolmeth)

" Date
" properties - constructor, prototype
let dateprop = ['constructor', 'prototype']
let datemeth = ['getDate', 'getDay', 'getFullYear', 'getHours', 'getMilliseconds',
      \ 'getMinutes', 'getMonth', 'getSeconds', 'getTime', 'getTimezoneOffset',
      \ 'getUTCDate', 'getUTCDay', 'getUTCFullYear', 'getUTCHours', 'getUTCMilliseconds',
      \ 'getUTCMinutes', 'getUTCMonth', 'getUTCSeconds',
      \ 'getYear', 'parse', 'parse',
      \ 'setDate', 'setDay', 'setFullYear', 'setHours', 'setMilliseconds',
      \ 'setMinutes', 'setMonth', 'setSeconds',
      \ 'setUTCDate', 'setUTCDay', 'setUTCFullYear', 'setUTCHours', 'setUTCMilliseconds',
      \ 'setUTCMinutes', 'setUTCMonth', 'setUTCSeconds', 'setYear', 'setTime',
      \ 'toGMTString', 'toLocaleString', 'toLocaleDateString', 'toLocaleTimeString',
      \ 'toSource', 'toString', 'toUTCString', 'UTC', 'valueOf', 'watch', 'unwatch']
let s:dates = s:MakeProperties('Date', dateprop, datemeth)

" Function
let funcprop = ['arguments', 'constructor', 'length', 'prototype']
let funcmeth = ['apply', 'call', 'toSource', 'toString', 'valueOf']
let s:funcs = s:MakeProperties('Function', funcprop, funcmeth)

" Arguments
let argsprop = ['callee', 'caller', 'length']
let argsmeth = []
let s:args = s:MakeProperties('arguments', argsprop, argsmeth)

" Math
let mathprop = ['E', 'LN2', 'LN10', 'LOG2E', 'LOG10E', 'PI', 'SQRT1_2', 'SQRT']
let mathmeth = ['abs', 'acos', 'asin', 'atan', 'atan2', 'ceil', 'cos', 'exp', 'floor',
      \ 'log', 'max', 'min', 'pow', 'random', 'round', 'sin', 'sqrt', 'tan',
      \ 'watch', 'unwatch']
let s:maths = s:MakeProperties('Math', mathprop, mathmeth)

" Number
let numbprop = ['MAX_VALUE', 'MIN_VALUE', 'NaN', 'NEGATIVE_INFINITY', 'POSITIVE_INFINITY',
      \ 'constructor', 'prototype']
let numbmeth = ['toExponential', 'toFixed', 'toPrecision', 'toSource', 'toString', 'valueOf',
      \ 'watch', 'unwatch']
let s:numbs = s:MakeProperties('Number', numbprop, numbmeth)

" Object
let objeprop = ['constructor', 'prototype']
let objemeth = ['eval', 'toSource', 'toString', 'unwatch', 'watch', 'valueOf']
let s:objes = s:MakeProperties('Object', objeprop, objemeth)

" RegExp
let regeprop = ['constructor', 'global', 'ignoreCase', 'lastIndex', 'multiline', 'source', 'prototype']
let regemeth = ['exec', 'test', 'toSource', 'toString', 'watch', 'unwatch']
let s:reges = s:MakeProperties('RegExp', regeprop, regemeth)

" String
let striprop = ['constructor', 'length', 'prototype']
let strimeth = ['anchor', 'big', 'blink', 'bold', 'charAt', 'charCodeAt', 'concat',
      \ 'fixed', 'fontcolor', 'fontsize', 'fromCharCode', 'indexOf', 'italics',
      \ 'lastIndexOf', 'link', 'match', 'replace', 'search', 'slice', 'small',
      \ 'split', 'strike', 'sub', 'substr', 'substring', 'sup', 'toLowerCase',
      \ 'toSource', 'toString', 'toUpperCase', 'watch', 'unwatch']
let s:stris = s:MakeProperties('String', striprop, strimeth)

" User created properties
"let user_props1 = filter(copy(file), 'v:val =~ "this\\.\\k"')
"let juser_props1 = join(user_props1, ' ')
"let user_props1 = split(juser_props1, '\zethis\.')
"unlet! juser_props1
"call map(user_props1, 'matchstr(v:val, "this\\.\\zs\\k\\+\\ze")')

"let user_props2 = filter(copy(file), 'v:val =~ "\\.prototype\\.\\k"')
"let juser_props2 = join(user_props2, ' ')
"let user_props2 = split(juser_props2, '\zeprototype\.')
"unlet! juser_props2
"call map(user_props2, 'matchstr(v:val, "prototype\\.\\zs\\k\\+\\ze")')
"let user_props = user_props1 + user_props2

"" HTML DOM properties
"" Anchors - anchor.
"let anchprop = ['accessKey', 'charset', 'coords', 'href', 'hreflang', 'id', 'innerHTML',
      "\ 'name', 'rel', 'rev', 'shape', 'tabIndex', 'target', 'type', 'onBlur', 'onFocus']
"let anchmeth = ['blur', 'focus']
"call map(anchmeth, 'v:val."("')
"let anths = anchprop + anchmeth
"" Area - area.
"let areaprop = ['accessKey', 'alt', 'coords', 'hash', 'host', 'hostname', 'href', 'id',
      "\ 'noHref', 'pathname', 'port', 'protocol', 'search', 'shape', 'tabIndex', 'target']
"let areameth = ['onClick', 'onDblClick', 'onMouseOut', 'onMouseOver']
"call map(areameth, 'v:val."("')
"let areas = areaprop + areameth
"" Base - base.
"let baseprop = ['href', 'id', 'target']
"let bases = baseprop
"" Body - body.
"let bodyprop = ['aLink', 'background', 'gbColor', 'id', 'link', 'scrollLeft', 'scrollTop',
      "\ 'text', 'vLink']
"let bodys = bodyprop
" Document - document.
let docuprop = ['anchors', 'applets', 'childNodes', 'embeds', 'forms', 'images', 'links', 'stylesheets',
      \ 'body', 'cookie', 'documentElement', 'domain', 'lastModified', 'referrer', 'title', 'URL']
let documeth = ['close', 'createAttribute', 'createElement', 'createTextNode', 'focus', 'getElementById',
      \ 'getElementsByName', 'getElementsByTagName', 'open', 'write', 'writeln',
      \ 'onClick', 'onDblClick', 'onFocus', 'onKeyDown', 'onKeyPress', 'onKeyUp',
      \ 'onMouseDown', 'onMouseMove', 'onMouseOut', 'onMouseOver', 'onMouseUp', 'onResize']
let docuxprop = ['attributes', 'childNodes', 'doctype', 'documentElement', 'firstChild',
      \ 'implementation', 'namespaceURI', 'nextSibling', 'nodeName', 'nodeType',
      \ 'nodeValue', 'ownerDocument', 'parentNode', 'previousSibling']
let docuxmeth = ['createAttribute', 'createCDATASection',
      \ 'createComment', 'createDocument', 'createDocumentFragment',
      \ 'createElement', 'createEntityReference', 'createProcessingInstruction',
      \ 'createTextNode']
let s:docus = s:MakeProperties('Function', docuprop+docuxprop, documeth+docuxmeth)
"" Form - form.
"let formprop = ['elements', 'acceptCharset', 'action', 'encoding', 'enctype', 'id', 'length',
      "\ 'method', 'name', 'tabIndex', 'target']
"let formmeth = ['reset', 'submit', 'onReset', 'onSubmit']
"call map(formmeth, 'v:val."("')
"let forms = formprop + formmeth
"" Frame - frame.
"let framprop = ['contentDocument', 'frameBorder', 'id', 'longDesc', 'marginHeight', 'marginWidth',
      "\ 'name', 'noResize', 'scrolling', 'src']
"let frammeth = ['blur', 'focus']
"call map(frammeth, 'v:val."("')
"let frams = framprop + frammeth
"" Frameset - frameset.
"let fsetprop = ['cols', 'id', 'rows']
"let fsetmeth = ['blur', 'focus']
"call map(fsetmeth, 'v:val."("')
"let fsets = fsetprop + fsetmeth
" History - history.
let histprop = ['length']
let histmeth = ['back', 'forward', 'go']
let s:hists = s:MakeProperties('History', histprop, histmeth)
"" Iframe - iframe.
"let ifraprop = ['align', 'frameBorder', 'height', 'id', 'longDesc', 'marginHeight', 'marginWidth',
      "\ 'name', 'scrolling', 'src', 'width']
"let ifras = ifraprop
"" Image - image.
"let imagprop = ['align', 'alt', 'border', 'complete', 'height', 'hspace', 'id', 'isMap', 'longDesc',
      "\ 'lowSrc', 'name', 'src', 'useMap', 'vspace', 'width']
"let imagmeth = ['onAbort', 'onError', 'onLoad']
"call map(imagmeth, 'v:val."("')
"let imags = histprop + imagmeth
"" Button - accessible only by other properties
"let buttprop = ['accessKey', 'disabled', 'form', 'id', 'name', 'tabIndex', 'type', 'value']
"let buttmeth = ['blur', 'click', 'focus', 'onBlur', 'onClick', 'onFocus', 'onMouseDown', 'onMouseUp']
"call map(buttmeth, 'v:val."("')
"let butts = buttprop + buttmeth
"" Checkbox - accessible only by other properties
"let checprop = ['accept', 'accessKey', 'align', 'alt', 'checked', 'defaultChecked',
      "\ 'disabled', 'form', 'id', 'name', 'tabIndex', 'type', 'value']
"let checmeth = ['blur', 'click', 'focus', 'onBlur', 'onClick', 'onFocus', 'onMouseDown', 'onMouseUp']
"call map(checmeth, 'v:val."("')
"let checs = checprop + checmeth
"" File upload - accessible only by other properties
"let fileprop = ['accept', 'accessKey', 'align', 'alt', 'defaultValue',
      "\ 'disabled', 'form', 'id', 'name', 'tabIndex', 'type', 'value']
"let filemeth = ['blur', 'focus', 'onBlur', 'onClick', 'onFocus', 'onMouseDown', 'onMouseUp']
"call map(filemeth, 'v:val."("')
"let files = fileprop + filemeth
"" Hidden - accessible only by other properties
"let hiddprop = ['defaultValue', 'form', 'id', 'name', 'type', 'value']
"let hidds = hiddprop
"" Password - accessible only by other properties
"let passprop = ['accept', 'accessKey', 'defaultValue',
      "\ 'disabled', 'form', 'id', 'maxLength', 'name', 'readOnly', 'size', 'tabIndex',
      "\ 'type', 'value']
"let passmeth = ['blur', 'click', 'focus', 'select', 'onBlur', 'onFocus', 'onKeyDown',
      "\ 'onKeyPress', 'onKeyUp']
"call map(passmeth, 'v:val."("')
"let passs = passprop + passmeth
"" Radio - accessible only by other properties
"let radiprop = ['accept', 'accessKey', 'align', 'alt', 'checked', 'defaultChecked',
      "\ 'disabled', 'form', 'id', 'name', 'tabIndex', 'type', 'value']
"let radimeth = ['blur', 'click', 'focus', 'select', 'onBlur', 'onFocus']
"call map(radimeth, 'v:val."("')
"let radis = radiprop + radimeth
"" Reset - accessible only by other properties
"let reseprop = ['accept', 'accessKey', 'align', 'alt', 'defaultValue',
      "\ 'disabled', 'form', 'id', 'name', 'size', 'tabIndex', 'type', 'value']
"let resemeth = ['blur', 'click', 'focus', 'select', 'onBlur', 'onFocus']
"call map(resemeth, 'v:val."("')
"let reses = reseprop + resemeth
"" Submit - accessible only by other properties
"let submprop = ['accept', 'accessKey', 'align', 'alt', 'defaultValue',
      "\ 'disabled', 'form', 'id', 'name', 'size', 'tabIndex', 'type', 'value']
"let submmeth = ['blur', 'click', 'focus', 'select', 'onClick', 'onSelectStart']
"call map(submmeth, 'v:val."("')
"let subms = submprop + submmeth
"" Text - accessible only by other properties
"let textprop = ['accept', 'accessKey', 'align', 'alt', 'defaultValue',
      "\ 'disabled', 'form', 'id', 'maxLength', 'name', 'readOnly',
      "\ 'size', 'tabIndex', 'type', 'value']
"let textmeth = ['blur', 'focus', 'select', 'onBlur', 'onChange', 'onFocus', 'onKeyDown',
      "\ 'onKeyPress', 'onKeyUp', 'onSelect']
"call map(textmeth, 'v:val."("')
"let texts = textprop + textmeth
"" Link - link.
"let linkprop = ['charset', 'disabled', 'href', 'hreflang', 'id', 'media',
      "\ 'rel', 'rev', 'target', 'type']
"let linkmeth = ['onLoad']
"call map(linkmeth, 'v:val."("')
"let links = linkprop + linkmeth
" Location - location.
let locaprop = ['href', 'hash', 'host', 'hostname', 'pathname', 'port', 'protocol',
      \ 'search']
let locameth = ['assign', 'reload', 'replace']
let s:locas = s:MakeProperties('Location', locaprop, locameth)
"" Meta - meta.
"let metaprop = ['charset', 'content', 'disabled', 'httpEquiv', 'name', 'scheme']
"let metas = metaprop
" Navigator - navigator.
let naviprop = ['plugins', 'appCodeName', 'appName', 'appVersion', 'cookieEnabled',
      \ 'platform', 'userAgent']
let navimeth = ['javaEnabled', 'taintEnabled']
let s:navis = s:MakeProperties('Navigator', naviprop, navimeth)
"" Object - object.
"let hobjeprop = ['align', 'archive', 'border', 'code', 'codeBase', 'codeType', 'data',
      "\ 'declare', 'form', 'height', 'hspace', 'id', 'name', 'standby', 'tabIndex',
      "\ 'type', 'useMap', 'vspace', 'width']
"let hobjes = hobjeprop
"" Option - accessible only by other properties
"let optiprop = ['defaultSelected',
      "\ 'disabled', 'form', 'id', 'index', 'label', 'selected', 'text', 'value']
"let optis = optiprop
"" Screen - screen.
"let screprop = ['availHeight', 'availWidth', 'colorDepth', 'height', 'width']
"let scres = screprop
"" Select - accessible only by other properties
"let seleprop = ['options', 'disabled', 'form', 'id', 'length', 'multiple', 'name',
      "\ 'selectedIndex', 'size', 'tabIndex', 'type', 'value']
"let selemeth = ['blur', 'focus', 'remove', 'onBlur', 'onChange', 'onFocus']
"call map(selemeth, 'v:val."("')
"let seles = seleprop + selemeth
"" Style - style.
"let stylprop = ['background', 'backgroundAttachment', 'backgroundColor', 'backgroundImage',
      "\ 'backgroundPosition', 'backgroundRepeat',
      "\ 'border', 'borderBottom', 'borderLeft', 'borderRight', 'borderTop',
      "\ 'borderBottomColor', 'borderLeftColor', 'borderRightColor', 'borderTopColor',
      "\ 'borderBottomStyle', 'borderLeftStyle', 'borderRightStyle', 'borderTopStyle',
      "\ 'borderBottomWidth', 'borderLeftWidth', 'borderRightWidth', 'borderTopWidth',
      "\ 'borderColor', 'borderStyle', 'borderWidth', 'margin', 'marginBottom',
      "\ 'marginLeft', 'marginRight', 'marginTop', 'outline', 'outlineStyle', 'outlineWidth',
      "\ 'outlineColor', 'outlineStyle', 'outlineWidth', 'padding', 'paddingBottom',
      "\ 'paddingLeft', 'paddingRight', 'paddingTop',
      "\ 'clear', 'clip', 'clipBottom', 'clipLeft', 'clipRight', 'clipTop', 'content',
      "\ 'counterIncrement', 'counterReset', 'cssFloat', 'cursor', 'direction',
      "\ 'display', 'markerOffset', 'marks', 'maxHeight', 'maxWidth', 'minHeight',
      "\ 'minWidth', 'overflow', 'overflowX', 'overflowY', 'verticalAlign', 'visibility',
      "\ 'width',
      "\ 'listStyle', 'listStyleImage', 'listStylePosition', 'listStyleType',
      "\ 'cssText', 'bottom', 'height', 'left', 'position', 'right', 'top', 'width', 'zindex',
      "\ 'orphans', 'widows', 'page', 'pageBreakAfter', 'pageBreakBefore', 'pageBreakInside',
      "\ 'borderCollapse', 'borderSpacing', 'captionSide', 'emptyCells', 'tableLayout',
      "\ 'color', 'font', 'fontFamily', 'fontSize', 'fontSizeAdjust', 'fontStretch',
      "\ 'fontStyle', 'fontVariant', 'fontWeight', 'letterSpacing', 'lineHeight', 'quotes',
      "\ 'textAlign', 'textIndent', 'textShadow', 'textTransform', 'textUnderlinePosition',
      "\ 'unicodeBidi', 'whiteSpace', 'wordSpacing']
"let styls = stylprop
"" Table - table.
"let tablprop = ['rows', 'tBodies', 'align', 'bgColor', 'border', 'caption', 'cellPadding',
      "\ 'cellSpacing', 'frame', 'height', 'rules', 'summary', 'tFoot', 'tHead', 'width']
"let tablmeth = ['createCaption', 'createTFoot', 'createTHead', 'deleteCaption', 'deleteRow',
      "\ 'deleteTFoot', 'deleteTHead', 'insertRow']
"call map(tablmeth, 'v:val."("')
"let tabls = tablprop + tablmeth
"" Table data - TableData.
"let tdatprop = ['abbr', 'align', 'axis', 'bgColor', 'cellIndex', 'ch', 'chOff',
      "\ 'colSpan', 'headers', 'noWrap', 'rowSpan', 'scope', 'vAlign', 'width']
"let tdats = tdatprop
"" Table row - TableRow.
"let trowprop = ['cells', 'align', 'bgColor', 'ch', 'chOff', 'rowIndex', 'sectionRowIndex',
      "\ 'vAlign']
"let trowmeth = ['deleteCell', 'insertCell']
"call map(trowmeth, 'v:val."("')
"let trows = trowprop + trowmeth
"" Textarea - accessible only by other properties
"let tareprop = ['accessKey', 'cols', 'defaultValue',
      "\ 'disabled', 'form', 'id', 'name', 'readOnly', 'rows',
      "\ 'tabIndex', 'type', 'value', 'selectionStart', 'selectionEnd']
"let taremeth = ['blur', 'focus', 'select', 'onBlur', 'onChange', 'onFocus']
"call map(taremeth, 'v:val."("')
"let tares = tareprop + taremeth
" Window - window.
let windprop = ['frames', 'closed', 'defaultStatus', 'document', 'encodeURI', 'event', 'history',
      \ 'length', 'location', 'name', 'onload', 'opener', 'parent', 'screen', 'self',
      \ 'status', 'top', 'XMLHttpRequest', 'ActiveXObject']
let windmeth = ['alert', 'blur', 'clearInterval', 'clearTimeout', 'close', 'confirm', 'focus',
      \ 'moveBy', 'moveTo', 'open', 'print', 'prompt', 'scrollBy', 'scrollTo', 'setInterval',
      \ 'setTimeout']
let s:winds = s:MakeProperties('Window', windprop, windmeth)
"" XMLHttpRequest - access by new xxx()
"let xmlhprop = ['onreadystatechange', 'readyState', 'responseText', 'responseXML',
      "\ 'status', 'statusText', 'parseError']
"let xmlhmeth = ['abort', 'getAllResponseHeaders', 'getResponseHeaders', 'open',
      "\ 'send', 'setRequestHeader']
"call map(xmlhmeth, 'v:val."("')
"let xmlhs = xmlhprop + xmlhmeth

"" XML DOM
"" Attributes - element.attributes[x].
"let xdomattrprop = ['name', 'specified', 'value']
" Element - anyelement.
let xdomelemprop = ['attributes', 'childNodes', 'firstChild', 'lastChild',
      \ 'namespaceURI', 'nextSibling', 'nodeName', 'nodeType', 'nodeValue',
      \ 'ownerDocument', 'parentNode', 'prefix', 'previousSibling', 'tagName']
let xdomelemmeth = ['appendChild', 'cloneNode', 'getAttribute', 'getAttributeNode',
      \ 'getElementsByTagName', 'hasChildNodes', 'insertBefore', 'normalize',
      \ 'removeAttribute', 'removeAttributeNode', 'removeChild', 'replaceChild',
      \ 'setAttribute', 'setAttributeNode']
let s:xdomelems = s:MakeProperties('DOMElement', xdomelemprop, xdomelemmeth)
"" Node - anynode.
"let xdomnodeprop = ['attributes', 'childNodes', 'firstChild', 'lastChild',
      "\ 'namespaceURI', 'nextSibling', 'nodeName', 'nodeType', 'nodeValue',
      "\ 'ownerDocument', 'parentNode', 'prefix', 'previousSibling']
"let xdomnodemeth = ['appendChild', 'cloneNode',
      "\ 'hasChildNodes', 'insertBefore', 'removeChild', 'replaceChild']
"call map(xdomnodemeth, 'v:val."("')
"let xdomnodes = xdomnodeprop + xdomnodemeth
"" NodeList
"let xdomnliss = ['length', 'item(']
"" Error - parseError.
"let xdomerror = ['errorCode', 'reason', 'line', 'linepos', 'srcText', 'url', 'filepos']
" }}}


autocmd vimenter * call DrawRjsMenu()
autocmd vimenter * call SetRjsCompleteLibarary(g:rjscomplete_library)
