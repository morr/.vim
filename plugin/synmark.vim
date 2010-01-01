" File Name: synmark.vim
" Maintainer: Moshe Kaminsky
" Last Modified: Mon 22 Nov 2004 09:37:37 AM IST

"=pod
"
"=head1 NAME
"
"synmark - highlight text at a fixed position
"
"=head1 SYNOPSIS
"
"This plugin provides commands for defining highlighting at fixed locations 
"(marks) in the text. It may be useful if you find yourself inserting text 
"just for the sake of highlighting. Instead of inserting this text, using this 
"plugins you will drop marks at the start and end of the text you wish to 
"highlight. The marks will not move when the text is changed, though, making 
"it useful mainly for readonly text.
"
"=head1 Introduction
"
"The typical scenario for using this plugin is this: You have another plugin 
"that displays some text in a vim buffer (for example, a man page viewer, or a 
"web browser - which was my motivation). You also want to highlight some parts 
"of this text (eg, some text should appear emphasized). These parts are known 
"to you by their location, but are not distinguished by any textual 
"characterisitcs. Normally, you would need to insert some special text to 
"identify these regions. Instead, using this plugin, you would do something 
"like:
"
"    :SynMark Emph Xstart Ystart Xend Yend
"
"for each of the regions, and the text is unaltered.
"
"Another use is to do something like
"
"    :vmap e :SynMark Emph<CR>
"
"Then pressing e when a text is visually selected will highlight that text.
"
"=cut
"

" don't run twice or when 'compatible' is set
if exists('g:synmark_version') || &compatible
  finish
endif
let g:synmark_version=0.2

" convert a character position to a byte position in the given line.
function! Char2Byte(line, char)
  if a:char < 2
    return a:char
  endif
  return strlen(substitute(a:line, '^\(.\{' . (a:char-1) . '\}\).*$', '\1', ''))+1
endfunction

"=pod
"
"=head1 Commands
"
"The following commands are used to define and mark regions:
"
"=over
"
"=item :SynMarkDef {name} [args]
"
"Define a new mark kind with name {name}. [args] is any arguments that can be 
"given to a B<syntax region> command, except for start, skip and end. These 
"arguments will affect all regions marked with the this word. If no [args] are 
"needed, this command can be omitted.
"
"=cut

command -bar -nargs=+ SynMarkDef call s:SynMarkDef(<q-args>)

function! s:SynMarkDef(args)
  let name = matchstr(a:args, '[^ ]*')
  let matchgroup = matchstr(a:args, 'matchgroup=[^ ]*')
  let args = substitute(a:args, '[^ ]* *', '', '')
  let args = substitute(args, 'matchgroup=[^ ]*', '', '')
  let s:command_{name} = 'syntax region synmark_' . name . 
        \'_@LS_@SC ' . matchgroup . 
        \' start=/\%@LSl\%@CS end=/\%@LEl@CE ' . args
endfunction

"=pod
"
"=item :SynMarkStart[!] {name} [col [line]]
"
"Mark the start of a region with name {name} at the given location. {name} is 
"any name valid for a syntax group name. B<col> is the column number and 
"B<line> is the line number. If either is omitted, it is taken from the 
"current cursor location. The value 0 for B<col> can be used to start the 
"region at the end of the given B<line>. This is useful for starting a region 
"in an empty line. See L</"synmark-bang"> for the meaning of the bang.
"
"=cut
"
command -bang -bar -nargs=+ SynMarkStart call s:SynMarkStart(<q-bang>, <f-args>)

function! s:SynMarkStart(bang, name,...)
  let s:line_{a:name} = a:0 > 1 ? a:2 : line('.')
  if a:0
    let s:col_{a:name} = a:bang ? a:1 
                               \: Char2Byte(getline(s:line_{a:name}), a:1)
  else
    let s:col_{a:name} = col('.')
  endif
endfunction

"=pod
"
"=item :SynMarkEnd[!] {name} [col [line]]
"
"Mark the end of a region with the given {name} at the given location. All 
"arguments are the same as for L</":SynMarkStart[!] {name} [col [line]]">.
"
"=cut
"
command -bang -bar -nargs=+ SynMarkEnd call s:SynMarkEnd(<q-bang>,<f-args>)

function! s:SynMarkEnd(bang, name,...)
  if ! exists('s:line_' . a:name)
    return
  endif
  if ! exists('s:command_' . a:name)
    call s:SynMarkDef(a:name)
  endif
  let el = a:0 > 1 ? a:2 : line('.')
  let eline = getline(el)
  let sl = s:line_{a:name}
  let sc = s:col_{a:name}
  let cs = sc ? sc . 'c./' : '$/'
  let cmd = substitute(s:command_{a:name}, '@LS', sl, 'g')
  let cmd = substitute(cmd, '@LE', el, 'g')
  if a:0
    let e = a:bang ? a:1 : Char2Byte(eline, a:1)
  else
    let e = col('.')
  endif
  if e
    if ( e == sc ) && ( el == sl )
      " start and end locations are the same ...
      if e == strlen(eline)
        " ... and it happens on the end of the line ..."
        let ce = '$/'
      else
        " ... or not - set the end pattern to be one byte after, and use 
        " offsets
        let c = substitute(eline, '^.*\(\%' . e . 'c.\).*$', '\1', '')
        let e = e + strlen(c)
        let ce = '\\%' . e . 'c./me=e-1,he=e-1'
      endif
    else
      let ce = '\\%' . e . 'c./'
    endif
  else
    let ce = '$/'
  endif
  let cmd = substitute(cmd, '@SC', sc, 'g')
  let cmd = substitute(cmd, '@CS', cs, 'g')
  let cmd = substitute(cmd, '@CE', ce, 'g')
  exec cmd
  exec 'highlight link synmark_' . a:name . '_' . sl . '_' . sc . 
        \' synmark_' . a:name
endfunction

"=pod
"
"=item :SynMark[!] {name} [start] [end]
"
"Mark the start and end of a region to highlight in one command. {name} is the 
"name of the syntax group. Each of B<start> and B<end> can be one of the 
"following: if two numbers are given, the first is the column and the second 
"is the line of the mark (the column interpretation depends on the bang, see 
"L</"synmark-bang">). If it is one number, it is the column number, and the 
"line is the current cursor line. If it is not a number, it should be 
"something acceptable by the I<col()> and I<line()> functions, like a (usual) 
"mark. If only B<start> is given, the current cursor position is used for 
"B<end>. Finally, if no location arguments are given, the last visual region 
"is used. Note that the two first numbers are always used as the start 
"coordinates, so that
"
"    :SynMark Foo 10 20
"
"means: highlight the region starting at column 10, line 20 and ending at the 
"cursor position, with group Foo. To highlight columns 10 to 20 of the current 
"line, use
"
"    :SynMark Foo 10 . 20
"
"=back
"
"The {name} in the commands above has the same function as the group name for 
"usual I<syntax> commands. However, it lives in a different namespace. The 
"L</":SynMarkDef {name} [args]"> command is used to define arguments for 
"subsequent synmark commands whose group has the same name. It may be used 
"several times, and each time will affect only marks dropped after the 
"decleration. If the matchgroup= argument is given (I<syn-matchgroup>), it 
"will affect the marker positions.
"
"X<synmark-bang>
"The column argument in the various commands is interpreted as the number of 
"B<characters> from the start of the line. Adding a bang to the marking 
"commands will cause this number to be interpreted as a B<byte> instead. These 
"are only different when there are characters larger than byte on the line.
"
"=cut
"
"
command -range -bar -bang -nargs=+ SynMark call s:SynMark(<q-bang>, <f-args>)

function! s:SynMark(bang, name,...)
  let sbang = a:bang
  let ebang = a:bang
  if a:0
    " determine start
    if a:1 =~ '^\d'
      let scol = a:1
      if a:2 =~ '^\d'
        let sline = a:2
        let index = 3
      else
        let sline = line('.')
        let index = 2
      endif
    else
      let scol = col(a:1)
      let sbang = 1
      let sline = line(a:1)
      let index = 2
    endif
    
    "determine end
    if a:0 >= index
      if a:{index} =~ '^\d'
        let ecol = a:{index}
        if a:0 > index
          let eline = a:{index+1}
        else
          let eline = line('.')
        endif
      else
        let ecol = col(a:{index})
        let ebang = 1
        let eline = line(a:{index})
      endif
    else
      let ecol = col('.')
      let ebang = 1
      let eline = line('.')
    endif
  else
    let scol = col("'<")
    let sline = line("'<")
    let ecol = col("'>")
    let eline = line("'>")
    let sbang = 1
    let ebang = 1
  endif

  call s:SynMarkStart(sbang, a:name, scol, sline)
  call s:SynMarkEnd(ebang, a:name, ecol, eline)
endfunction
    
"=pod
"
"The following commands are used for defining highlighting for the marked 
"groups:
"
"=over
"
"=item :SynMarkHighlight[!] {name} {args}
"
"Defines highlighting for the given synmark group {name}. The bang and the 
"rest of the arguments are interpreted exactly as for the I<:highlight> 
"command.
"
"=cut
"
command -bar -bang -nargs=+ SynMarkHighlight highlight<bang> synmark_<args>

"=pod
"
"=item :SynMarkLink[!] {name} {to-group}
"
"Link the synmark group {name} to {to-group}. {to-group} and the bang are as 
"in the usual highlight linking, I<:highlight-link>. {to-group} may also be 
"NONE.
"
"=back
"
"=cut
"
command -bar -bang -nargs=+ SynMarkLink highlight<bang> link synmark_<args>

"=pod
"
"=head1 VERSION
"
"Version 0.1. For vim version 6.3.
"
"=head1 AUTHOR
"
"Moshe Kaminsky <kaminsky@math.huji.ac.il>
"
"=cut
"

