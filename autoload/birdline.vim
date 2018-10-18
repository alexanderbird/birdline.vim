" We'll need to keep track of which window is active
let s:current_buffer_id = win_getid()
augroup CustomStatusLineAugroup
  autocmd!
  autocmd BufEnter,BufNew * let s:current_window_id = win_getid()
augroup END

function! GetFileEncoding()
  return strlen(&fileencoding) ? &fileencoding : 'none'
endfunction

function! GetRelativePath()
  let l:path = expand('%')
  if l:path[0] == '/'
    " the file is an absolute path (not under current directory)
    let l:pathParts = split(l:path, '/')
    let l:workingDirectoryParts = split(getcwd(), '/')
    let l:relativePath = []
    let l:i = 0
    let l:pathsHaveDiverged = 0
    while l:i < len(pathParts)
      let l:pathsHaveDiverged = l:pathsHaveDiverged || get(l:pathParts, i) != get(l:workingDirectoryParts, i)
      if l:pathsHaveDiverged
        call add(l:relativePath, l:pathParts[i])
      endif
      let l:i += 1
    endwhile

    let l:pathsHaveDiverged = 0
    let l:i = 0
    while l:i < len(l:workingDirectoryParts)
      let l:pathsHaveDiverged = l:pathsHaveDiverged || get(l:pathParts, i) != get(l:workingDirectoryParts, i)
      if l:pathsHaveDiverged
        call insert(l:relativePath, '..')
      endif
      let l:i += 1
    endwhile

    if(len(l:relativePath) == 0)
      " Top level file
      let l:file_name = expand('%:t')
      return './' . l:file_name
    else
      " File nested somewhere
      return './' . join(l:relativePath, '/')
    endif
  else
    return './' . l:path
  endif
endfunction

function! UseCondensedRightHandSide()
  let l:width = winwidth(winnr())
  return l:width < 70
endfunction


function! GetStatusLineLeftHandSide(mode)
  let l:width = winwidth(winnr())
  let l:icon = { 
    \'Modified': '٩(^‿^)۶  ',
    \'Unmodified': '٩(-‿-)۶  ',
    \'Inactive': '꒰꒡⌓ ꒡꒱',
    \'InactiveAndModified': '꒰◔ ⌓ ◔ ꒱',
    \'ReadOnly': '  (ಠ _ ಠ) ',
    \'ReadOnlyAndModified': '🔥(ಠ ⌓ ಠ)🔥 '
  \}

  let l:read_only_indicator = &readonly ? '[ro]' : ''
  let l:long_version = join([
    \ ' ',
    \ l:icon[a:mode],
    \ GetRelativePath(),
    \ ' [',
        \ GetFileEncoding(),
        \ ',',
        \ &fileformat, 
    \ '] ',
    \ &filetype,
    \ l:read_only_indicator,
  \], '')

  let l:file_name = expand('%:t')
  let l:medium_version = join([
    \ ' ',
    \ l:icon[a:mode],
    \ l:file_name,
    \ ' [',
        \ GetFileEncoding(),
        \ ',',
        \ &fileformat, 
    \ '] ',
    \ &filetype,
    \ l:read_only_indicator,
  \], '')

  let l:short_version = join([
    \ ' ',
    \ l:icon[a:mode],
    \ l:file_name,
  \], '')

  let l:tiny_version = l:file_name

  let l:estimated_right_hand_part_width = UseCondensedRightHandSide() ? 6 : 35
  let l:breakpoint = l:width - l:estimated_right_hand_part_width
  if(strdisplaywidth(l:long_version) < l:breakpoint)
    return l:long_version
  elseif (strdisplaywidth(l:medium_version) < l:breakpoint) 
    return l:medium_version
  elseif (strdisplaywidth(l:short_version) < l:breakpoint)
    return l:short_version
  else
    return l:tiny_version
  endif
endfunction

function! LPad(text, width)
    let l:width = strdisplaywidth(a:text) 
    let l:pad = a:width - l:width
    return repeat(' ', l:pad) . a:text
endfunction

function! RPad(text, width)
    let l:width = strdisplaywidth(a:text) 
    let l:pad = a:width - l:width
    return a:text . repeat(' ', l:pad)
endfunction

function! Superscript(number)
  let l:result = ''
  let l:subscripts = { '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴', '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹' }
  for char in split(string(a:number), '\zs')
    let l:result .= l:subscripts[char]
  endfor
  return l:result
endfunction


function! Subscript(number)
  let l:result = ''
  let l:subscripts = { '0': '₀', '1': '₁', '2': '₂', '3': '₃', '4': '₄', '5': '₅', '6': '₆', '7': '₇', '8': '₈', '9': '₉' }
  for char in split(string(a:number), '\zs')
    let l:result .= l:subscripts[char]
  endfor
  return l:result
endfunction

function! GetPercentageIcon(icons, percentage)
  let l:percentage_icons = split(a:icons, '\zs')

  let l:index = 0
  let l:step_size = 0.5/(len(l:percentage_icons) - 1)
  for icon in l:percentage_icons 
    let l:cutoff = (1 + (2 * l:index)) * l:step_size
    if(a:percentage < l:cutoff)
      return icon
    endif
    let l:index += 1
  endfor
endfunction

function! CountDigits(number)
  return a:number < 10 ? 1 : a:number < 100 ? 2 : a:number < 1000 ? 3 : a:number < 10000 ? 4 : 5
endfunction

function! GetStatusLineRightHandSide(mode)
  let l:width = col('$')
  let l:height = line('$')

  let l:column = col('.')
  let l:line = line('.')

  let l:percentage = (l:line * 1.0)/ l:height
  let l:percentage_part = printf('%3.0f%%⤓ ', l:percentage * 100)

  if(UseCondensedRightHandSide())
    return l:percentage_part
  endif

  let l:column_part = 'col ' . LPad(Superscript(l:column), 3) . '/' . RPad(Subscript(l:width), 3)

  let l:height_padding = CountDigits(l:height) 
  let l:line_part = 'line ' . LPad(Superscript(l:line), l:height_padding) . '/' . RPad(Subscript(l:height), l:height_padding)

  let l:divider = ' │ '
  return l:column_part . l:divider . l:line_part . l:divider . l:percentage_part
endfunction

function! GetPadding(mode)
  " We need padding so that our custom syntax highlighting group applies to the
  " entire status line. Without it, the syntax highlight group only applies to
  " the text

  let l:len_left = strdisplaywidth(GetStatusLineLeftHandSide(a:mode))
  let l:len_right = strdisplaywidth(GetStatusLineRightHandSide(a:mode))
  let l:width = winwidth(winnr())
  let l:padding_width = l:width - l:len_left - l:len_right + (UseCondensedRightHandSide() ? 2 : 1)
  return repeat(' ', l:padding_width)
endfunction

function! IsMode(mode)
  if(win_getid() == s:current_window_id)
    if(&readonly)
      let l:mode = &modified ? 'ReadOnlyAndModified' : 'ReadOnly'
    else
      let l:mode = &modified ? 'Modified' : 'Unmodified'
    endif
  else
    let l:mode = &modified ? 'InactiveAndModified' : 'Inactive'
  endif
  return a:mode == l:mode
endfunction

function! ShowIf(condition, text)
  return a:condition ? a:text : ''
endfunction

function! birdline#SetStatusLine()
  set statusline=
  let l:modes = ['Inactive', 'InactiveAndModified', 'Modified', 'Unmodified', 'ReadOnly', 'ReadOnlyAndModified' ]

  " Left area
  for mode in l:modes
    exec 'set statusline+=%#StatusLineWhen' . mode . '#' 
    exec "set statusline+=%{ShowIf(IsMode('" . mode . "'),GetStatusLineLeftHandSide('" . mode . "'))}"
    set statusline+=%*
  endfor

  " Left/right separator
  set statusline+=%=

  " Right area
  for mode in l:modes
    exec 'set statusline+=%#StatusLineWhen' . mode . '#' 
    exec "set statusline+=%{ShowIf(IsMode('" . mode . "'),GetPadding('" . mode . "'))}"
    exec "set statusline+=%{ShowIf(IsMode('" . mode . "'),GetStatusLineRightHandSide('" . mode . "'))}"
    set statusline+=%*
  endfor
endfunction
