" Vim Board: Easy notes and shortcuts
" Author: Azabiong
" License: MIT
" Source: https://github.com/azabiong/vim-board
" Version: 1.26

scriptencoding utf-8
if exists("s:Board")
  finish
endif
let s:cpo_save = &cpo
set cpo&vim

let g:BoardPath = get(g:, 'BoardPath', '')
let g:BoardRegister = get(g:,'BoardRegister', 'b')
let g:BoardMenuExpand = get(g:,'BoardMenuExpand', 220)

let s:Version = '1.26'
let s:Board = #{ plug:expand('<sfile>:h'), path:'', main:'', current:'', prev:'', hold:'',
               \ menu:'', restore:0, input:'', change:'', keys:0, enter:0, match:0,
               \ timer:0, interval:1, stack:[#{ key:'', cmd:[], run:0 }], range:1024,
               \ scratch:#{ pad:-1, name:' Board* '},
               \ }
let s:Links = #{ bufnr:{'key':'path'}, order:[] }
let s:Input = #{ timer:0, interval:20, wait:220, reltime:0 }
let s:Help  = #{ Update:'', win:0, buf:-1 }
let s:KeyMap = {'+':"4\<C-E>", '-':"4\<C-Y>", 'v':"\<C-F>", '^':"\<C-B>"}
let s:Sentence = ['if', 'for', 'while']
let s:Optional = '/?nNgGHML'

function s:LoadColors()
  if has('gui_running') || (has('termguicolors') && &termguicolors) || &t_Co >= 256
    if &background == 'dark'
      let l:colors = [
        \ ['BoardSection',    'ctermfg=219 ctermbg=NONE cterm=bold guifg=#f8a0f8 guibg=NONE    gui=bold'],
        \ ['BoardCfgLinks',   'ctermfg=215 ctermbg=NONE cterm=bold guifg=#f8b868 guibg=NONE    gui=bold'],
        \ ['BoardGroup',      'ctermfg=147 ctermbg=NONE cterm=bold guifg=#aabcf0 guibg=NONE    gui=bold'],
        \ ['BoardLink',       'ctermfg=109 ctermbg=NONE cterm=NONE guifg=#98bcbc guibg=NONE    gui=NONE'],
        \ ['BoardLed1',       'ctermfg=159 ctermbg=60   cterm=NONE guifg=#a0f0f0 guibg=#585888 gui=NONE'],
        \ ['BoardLed2',       'ctermfg=225 ctermbg=96   cterm=NONE guifg=#f8d8f8 guibg=#905080 gui=NONE'],
        \ ['BoardLed3',       'ctermfg=229 ctermbg=94   cterm=NONE guifg=#f0f0a8 guibg=#866c50 gui=NONE'],
        \ ['BoardBracket',    'ctermfg=243 ctermbg=238  cterm=NONE guifg=#787a78 guibg=#404242 gui=NONE'],
        \ ['BoardMarker',     'ctermfg=114 ctermbg=NONE cterm=bold guifg=#88c888 guibg=NONE    gui=bold'],
        \ ['BoardGuide',      'ctermfg=59  ctermbg=NONE cterm=NONE guifg=#606060 guibg=NONE    gui=NONE'],
        \ ['BoardPlus',       'ctermfg=189 ctermbg=NONE cterm=bold guifg=#cceaf8 guibg=NONE    gui=bold'],
        \ ['BoardSpecial',    'ctermfg=179 ctermbg=NONE cterm=bold guifg=#e69f6c guibg=NONE    gui=bold'],
        \ ['BoardEqual',      'ctermfg=183 ctermbg=NONE cterm=NONE guifg=#e0acf8 guibg=NONE    gui=NONE'],
        \ ['BoardColon',      'ctermfg=180 ctermbg=NONE cterm=NONE guifg=#cfa080 guibg=NONE    gui=NONE'],
        \ ['BoardQuestion',   'ctermfg=115 ctermbg=NONE cterm=bold guifg=#98c8a8 guibg=NONE    gui=bold'],
        \ ['BoardExclamation','ctermfg=187 ctermbg=NONE cterm=bold guifg=#e6dfa8 guibg=NONE    gui=bold'],
        \ ['BoardAmpersand',  'ctermfg=110 ctermbg=NONE cterm=bold guifg=#80bfcf guibg=NONE    gui=bold'],
        \ ]
    else
      let l:colors = [
        \ ['BoardSection',    'ctermfg=127 ctermbg=NONE cterm=bold guifg=#af00af guibg=NONE    gui=bold'],
        \ ['BoardCfgLinks',   'ctermfg=166 ctermbg=NONE cterm=bold guifg=#d85820 guibg=NONE    gui=bold'],
        \ ['BoardGroup',      'ctermfg=25  ctermbg=NONE cterm=bold guifg=#2a58b0 guibg=NONE    gui=bold'],
        \ ['BoardLink',       'ctermfg=61  ctermbg=NONE cterm=NONE guifg=#5040a8 guibg=NONE    gui=NONE'],
        \ ['BoardLed1',       'ctermfg=18  ctermbg=195  cterm=NONE guifg=#000078 guibg=#d8f8f8 gui=NONE'],
        \ ['BoardLed2',       'ctermfg=88  ctermbg=225  cterm=NONE guifg=#780000 guibg=#fcd8fa gui=NONE'],
        \ ['BoardLed3',       'ctermfg=234 ctermbg=230  cterm=NONE guifg=#282800 guibg=#f8f8d8 gui=NONE'],
        \ ['BoardBracket',    'ctermfg=248 ctermbg=188  cterm=NONE guifg=#a8a8a8 guibg=#d8d8d8 gui=NONE'],
        \ ['BoardMarker',     'ctermfg=28  ctermbg=NONE cterm=bold guifg=#008000 guibg=NONE    gui=bold'],
        \ ['BoardGuide',      'ctermfg=252 ctermbg=NONE cterm=NONE guifg=#cccccc guibg=NONE    gui=NONE'],
        \ ['BoardPlus',       'ctermfg=63  ctermbg=NONE cterm=bold guifg=#5f5fff guibg=NONE    gui=bold'],
        \ ['BoardSpecial',    'ctermfg=130 ctermbg=NONE cterm=bold guifg=#a04f00 guibg=NONE    gui=bold'],
        \ ['BoardEqual',      'ctermfg=91  ctermbg=NONE cterm=NONE guifg=#8200a8 guibg=NONE    gui=NONE'],
        \ ['BoardColon',      'ctermfg=52  ctermbg=NONE cterm=NONE guifg=#6c2418 guibg=NONE    gui=NONE'],
        \ ['BoardQuestion',   'ctermfg=29  ctermbg=NONE cterm=bold guifg=#2e8068 guibg=NONE    gui=bold'],
        \ ['BoardExclamation','ctermfg=173 ctermbg=NONE cterm=bold guifg=#d87860 guibg=NONE    gui=bold'],
        \ ['BoardAmpersand',  'ctermfg=32  ctermbg=NONE cterm=bold guifg=#2f8fcf guibg=NONE    gui=bold'],
        \ ]
    endif
  else
      let l:colors = [
        \ ['BoardSection',    'ctermfg=Magenta' ],
        \ ['BoardCfgLinks',   'ctermfg=Red'     ],
        \ ['BoardGroup',      'ctermfg=Cyan'    ],
        \ ['BoardLink',       'ctermfg=DarkBlue'],
        \ ['BoardLed1',       'ctermfg=White ctermbg=darkCyan'   ],
        \ ['BoardLed2',       'ctermfg=White ctermbg=darkMagenta'],
        \ ['BoardLed3',       'ctermfg=White ctermbg=darkYellow' ],
        \ ['BoardMarker',     'ctermfg=Green' ],
        \ ['BoardGuide',      'ctermfg=Gray'  ],
        \ ['BoardPlus',       'ctermfg=Blue'  ],
        \ ['BoardSpecial',    'ctermfg=Red'   ],
        \ ['BoardQuestion',   'ctermfg=Green' ],
        \ ['BoardExclamation','ctermfg=Yellow'],
        \ ]
  endif
  for l:c in l:colors
    if empty(s:GetColor(l:c[0]))
      exe 'hi' l:c[0] l:c[1]
    endif
  endfor
endfunction

function s:GetColor(color)
  if hlexists(a:color)
    return matchstr(execute('hi '.a:color), '\(\<cterm\|\<gui\|\<links\).*')
  endif
  return ''
endfunction

function s:WinPopup(on, line='')
  if a:on && !s:Help.win
    let l:opt = #{ line:&lines - &ch, col:1, pos:'botleft', wrap:0}
    let s:Help.win = popup_create('', l:opt)
    let s:Help.buf = winbufnr(s:Help.win)
    call setwinvar(s:Help.win, '&wincolor', 'BoardHelp')
  elseif !a:on && s:Help.win
    call popup_close(s:Help.win)
    let s:Help.win = 0
    let s:Help.buf = 0
  endif
  if s:Help.win && s:Help.buf
    call setbufline(s:Help.buf, 1, a:line.repeat(' ', &columns))
    redraw
  endif
endfunction

function s:WinFloat(on, line='')
  if a:on && !s:Help.win
    let l:opts = {'relative':'editor', 'width':&columns, 'height':1,
                 \ 'row':&lines - &ch, 'col':0, 'anchor':'SW', 'style':'minimal'}
    if !bufexists(s:Help.buf)
      let s:Help.buf = nvim_create_buf(v:false, v:true)
    endif
    let s:Help.win = nvim_open_win(s:Help.buf, 0, l:opts)
    call nvim_win_set_option(s:Help.win, 'winhl', 'Normal:BoardHelp')
  elseif !a:on && s:Help.win
    call nvim_win_close(s:Help.win, 0)
    let s:Help.win = 0
  endif
  if s:Help.win && s:Help.buf
    call nvim_buf_set_lines(s:Help.buf, 0, -1, v:true, [a:line])
    redraw
  endif
endfunction

function s:Nop(...)
endfunction

function s:SetMainBoard()
  if empty(g:BoardPath)
    let l:path = expand('~/.config/boards')
    if !isdirectory(l:path)
      let l:vim = (match(s:Board.plug, '/vimfiles') != -1) ? 'vimfiles' : '.vim'
      let l:vim = expand('$HOME').'/'.l:vim.'/after/vim-board'
      if isdirectory(l:vim)
        let l:path = l:vim
      endif
    endif
  else
    let l:path = expand(g:BoardPath)
  endif

  let l:main = l:path.'/_main_.board'
  let l:edit = ''
  call s:SelectWin()
  if !filereadable(l:main)
    let l:edit = " BoardPath: ".fnamemodify(l:main, ':~')."/\n"
    if confirm(l:edit, " Create file?  &yes\n&no", 0) != 1
      return
    endif
    let l:dir = fnamemodify(l:main, ':h')
    if !isdirectory(l:dir) && !mkdir(l:dir, 'p')
      return
    endif
    let l:base = s:Board.plug.'/_main'
    silent exe "edit" l:main
    silent exe "0read" l:base
    silent exe "bwipe" l:base
    redraw
    call s:Edit()
    silent write
  endif
  let s:Board.path = fnamemodify(l:main, ':p:h')
  let s:Board.main = l:main
  let s:Board.prev = l:main
  call s:OpenFile(l:main, 2)
  if empty(l:edit)
    call s:Prompt()
  endif
endfunction

function s:AddNewBoard()
  if !isdirectory(s:Board.path)
    call s:Warning(' * Path not found  '.s:Board.path)
    return
  endif
  let l:buf = bufnr(s:Board.path)
  if l:buf == -1 || bufwinnr(l:buf) == -1 || bufname(l:buf) != s:Board.path
    enew
    exe "Explore" s:Board.path
    redraw
  endif
  echohl BoardGroup
  let l:file = trim(input(' New board name: '))
  echohl None
  echo ''
  if empty(l:file) | return | endif

  let l:file = (l:file =~? '\v\.(board|bd)$') ? l:file : l:file.'.board'
  let l:file = s:Board.path.'/'.l:file
  if !filereadable(l:file)
    exe "edit" l:file
    %delete
    let l:base = s:Board.plug.'/_new'
    silent exe "0read" l:base
    silent exe "bwipe" l:base
    call setline(1, '# '.fnamemodify(l:file, ':t:r'))
  endif
  call s:OpenFile(l:file, 2)
  call s:Edit()
  echo ''
endfunction

function s:BoardFile(path)
  return index(['board', 'bd'], tolower(fnamemodify(a:path, ':e'))) != -1
endfunction

function s:Process(key)
  let l:board = []  " [board, load, prompt]
  let l:current = (&filetype == 'board') ? expand('%:p') : s:Board.current

  if     a:key == '>' | return s:UnloadLinks()
  elseif a:key == '+' | return s:AddNewBoard()
  elseif a:key == '-' | let l:board = [s:Board.prev, 0, 1]
  elseif a:key == '=' | let l:board = [s:Board.main, 2, 1]
  elseif a:key == '.' | let l:board = [l:current, 0, 0]
  elseif a:key == '.?'| let l:board = [l:current, 0, 1]
  elseif a:key == '<' | let l:board = [l:current, 1, 1]
                        if &modified && !s:ConfirmSave()
                          return s:Prompt()
                        endif
  endif
  if !empty(l:board)
    call s:SelectWin()
    call s:OpenFile(l:board[0], l:board[1])
    return l:board[2] ? s:Prompt() : s:Status('')
  else
    if s:Board.timer
      call timer_stop(s:Board.timer)
    endif
    let s:Board.stack = []
    let s:Board.range = 1024
    let s:Board.interval = 1
    call s:RunLink(a:key)
  endif
endfunction

function s:Restore(base)
  if a:base && s:Board.restore && s:Board.current != s:Board.hold && exists("w:BoardOverlap")
    let l:o = w:BoardOverlap
    if bufexists(l:o.buf)
      exe "buf" l:o.buf
      call winrestview(l:o.view)
    endif
    unlet w:BoardOverlap
  endif
endfunction

function s:RunLink(key)
  let l:link = s:GetLink(a:key)
  if empty(l:link)
    call s:Warning(' * Link not found  '.a:key)
    return 0
  else
    let l:path = expand(l:link.path)
  endif

  let l:info = fnamemodify(l:path, ':~')
  let l:base = empty(s:Board.stack)
  if empty(l:path)
    " commands only
    call s:Restore(l:base)
  elseif isdirectory(l:path)
    if &lazyredraw | redraw | endif
    exe "tcd" l:path
    call s:Restore(l:base)
    echohl BoardGroup | echo ' '.l:info | echohl None
  else
    if filereadable(l:path)
      let l:path = fnamemodify(l:path, ':p')
    else
      let l:path = s:Board.path.'/'.l:path
      if !filereadable(l:path)
        call s:Warning(' * Path not found ('.l:link.board.'  '.a:key.') '.l:info)
        return 0
      endif
    endif
    call s:SelectWin()
    if s:BoardFile(l:path)
      if s:OpenFile(l:path, 2) && l:base && !len(l:link.command)
        call s:Prompt()
        return 1
      endif
    else
      call s:OpenFile(l:path)
    endif
    echo ''
  endif
  if len(l:link.command)
    let s:Board.stack += [{'key':a:key, 'cmd':l:link.command, 'run':0}]
    if l:base
      let s:Board.timer = timer_start(8, function('s:RunCmd'))
    endif
  endif
  return 1
endfunction

function s:AddLink(key)
  if len(s:Board.stack) > s:Board.range
    return s:Error('Stack Overflow  '.s:Board.range)
  endif
  let l:key = matchstr(a:key, '&\?\zs\S\+')
  return s:RunLink(l:key)
endfunction

function s:OpenFile(path, load=0)
  let l:buf = bufnr(a:path)
  if !filereadable(a:path) && l:buf == -1 | return | endif
  if l:buf == -1
    exe "edit" a:path
    let l:buf = bufnr(a:path)
  else
    exe "buf" l:buf
  endif
  if bufnr(s:Board.hold) != l:buf
    let s:Board.hold = ''
  endif
  if s:BoardFile(a:path)
    call s:SetOrder(a:path)
    if a:load
      call s:SetBoard()
      if !s:Loaded()
        call s:LoadLinks(a:path, a:load)
      endif
    elseif !s:Loaded()
      call s:CheckLinks()
    endif
    call s:SetSyntax()
  endif
  redraw
  return 1
endfunction

" returns {board, path, command[]}
function s:GetLink(key)
  for b in s:Links.order
    if has_key(s:Links, b) && has_key(s:Links[b], a:key)
      let l:line = s:Links[b][a:key]
      if l:line[0] == '|'
        let l:line = ' |  '.l:line
      endif
      let l:mode = stridx(l:line, '|:')
      let l:cmd = ''
      if l:mode != -1
        let l:cmd = trim(l:line[l:mode+2:])
        let l:line = l:line[:l:mode-1]
      endif
      let l:list = map(split(l:line, '\v\ \|(\|)@!'), {i,v -> trim(v)})
      if !empty(l:cmd)
        call extend(l:list, [':', l:cmd])
      endif
      return #{board: s:Links[b]['#'.b], path: l:list[0], command: l:list[1:]}
    endif
  endfor
endfunction

function s:GetKeys(key)
  let l:keys = []
  for b in s:Links.order
    if has_key(s:Links, b)
      let l:keys += filter(keys(s:Links[b]), {i,v -> stridx(v, a:key) == 0})
    endif
  endfor
  return uniq(sort(l:keys))
endfunction

function s:SetOrder(path)
  let l:bufnr = bufnr(a:path)
  if empty(s:Board.current) || bufnr(s:Board.current) != l:bufnr
    let [s:Board.current, s:Board.prev] = [a:path, s:Board.current]
    if empty(s:Board.prev)
      let s:Board.prev = s:Board.current
    endif
    call filter(s:Links.order, {i,v -> v != l:bufnr})
    call insert(s:Links.order, l:bufnr)
  endif
endfunction

function s:Loaded()
  if exists("b:Board")
    return 1 + b:Board.list
  endif
endfunction

function s:CheckLinks(op=0)
  if !exists("b:BoardLinks") || a:op
    let b:BoardLinks = search('^:Links\c\>', 'nw')
  endif
endfunction

function s:LoadLinks(path='', type=0)
  let l:board = empty(a:path) ? expand('%:p') : a:path
  let l:list = a:type == 2
  if !exists("b:Board")
    let b:Board = {'list': l:list}
  else
    let b:Board.list = b:Board.list || l:list
  endif
  if !filereadable(l:board) | return | endif
  let l:bufnr = bufnr(l:board)
  let s:Links[l:bufnr] = {}
  let l:list = s:Links[l:bufnr]
  let l:list['#'.l:bufnr] = fnamemodify(l:board, ':t')
  let l:pos = getpos('.')
  let l:opt = 'c'
  call cursor(1, 1)
  while search('^:Links\c\>', l:opt.'W')
    let l:key = ''
    let [l:num, l:end] = [line('.'), line('$')]
    while l:num <= l:end
      let l:num += 1
      let l:link = s:ReadLine(l:num)
      if empty(l:link)
        break
      elseif len(l:link) > 1
        if empty(l:link[0])
          " multi-line
          if !empty(l:key)
            let l:list[l:key] .= l:link[1]
          endif
        else
          let l:key = l:link[0]
          let l:list[l:key] = l:link[1]
        endif
      endif
    endwhile
    let l:opt = ''
    let b:BoardLinks = 1
  endwhile
  call s:SetSyntax(1)
  call setpos('.', l:pos)
endfunction

" returns [] end_of_section,  [''] no_value,  ['key','path|cmd|cmd..']
function s:ReadLine(num)
  let l:line = getline(a:num)
  " section: column 1
  if !empty(line[0]) && stridx(':# ', line[0]) == -1
    return []
  endif
  " key: column > 5
  if match(l:line, '\v[: ]\ {4,}\S') != -1
    let l:index = l:line[0] == ':'
    let l:line = trim(l:line[l:index:])
    if stridx('-=+<>:#', line[0]) == -1
      let l:key = matchstr(l:line, '\S\+\ze')
      if l:key == '|'
        let l:key = ''
      endif
      let l:value = trim(l:line[len(l:key):])
      if !empty(l:value)
        return [l:key, l:value]
      endif
    endif
  endif
  return ['']
endfunction

function s:UnloadLinks()
  if &filetype != 'board' | return | endif
  let l:buf = bufnr()
  if exists("s:Links[".l:buf."]") && !empty(s:Links[l:buf]) && s:Links[l:buf]['#'.l:buf] != '_main_.board'
    let s:Links[l:buf] = {}
    if exists("b:Board")
      call s:SetSyntax(-1)
      unlet b:Board
    endif
  endif
  call s:Prompt()
endfunction

function s:SetBoard()
  setl ft=board et ts=4 sts=4 sw=0 fdm=marker nonu
  call s:SetColumn()
endfunction

function s:SetColumn(op=0)
  if &fdc < 1 && &scl != 'yes'
    setl fdc=1
    if a:op | redraw | endif
  endif
  if &nu
    setl nonu
    if a:op | redraw | endif
  endif
endfunction

function s:SetSyntax(op=0)
  if a:op < 0
    if exists("b:Board.syntax")
      syn clear BoardCfgLinks
      unlet b:Board.syntax
    endif
  elseif a:op > 0 || exists("b:Board.syntax")
    syn match BoardCfgLinks "^:links\c\>" contained
    let b:Board.syntax = 'on'
  endif
endfunction

function s:ClearSyntaxGuide()
  let [i, l:end] = [0, line('$')]
  while i <= l:end
    let i += 1
    let l:line = getline(i)
    let l:char = l:line[0]
    if l:char == '|' || (l:char == ':' && l:line !~ '^:\w')
      call setline(i, ' '.l:line[1:])
    endif
  endwhile
endfunction

function s:SetSpeed(freq)
  if (a:freq ==? 'max')
    let s:Board.interval = 0
  else
    let s:Board.interval = 1000 / min([max([a:freq * 4/3, 1]), 1000])
  endif
endfunction

function s:SetStack(range)
  let s:Board.range = max([a:range, 1024])
endfunction

function s:RunCmd(...)
  if empty(s:Board.stack) | return | endif

  let l:unit = s:Board.stack[-1]
  if l:unit.run >= len(l:unit.cmd)
    unlet s:Board.stack[-1]
    if !len(s:Board.stack)
      let s:Board.timer = 0
    else
      let s:Board.timer = timer_start(s:Board.interval, function('s:RunCmd'))
    endif
    return
  endif

  let l:cmd = l:unit.cmd[l:unit.run]
  if !empty(l:cmd)
    if match(l:cmd, '\v^\S+\.(board|bd)$\c') == 0
      let l:path = l:cmd
      if !filereadable(l:path)
        let l:path = s:Board.path.'/'.l:path
        if !filereadable(l:path)
          return s:Error('Path not found')
        endif
      endif
      call s:SelectWin()
      call s:OpenFile(l:path, 2)
    elseif l:cmd[0] == '&'
      if !s:AddLink(l:cmd)
        return
      endif
    else
      if l:cmd == ':'
        let l:unit.run += 1
        let l:cmd = l:unit.cmd[l:unit.run]
      else
        let l:end = s:CheckSentence(l:unit, l:unit.run)
        if l:end == -1
          return s:Error(l:unit.error)
        elseif l:end > l:unit.run
          let l:cmd = []
          for i in range(l:unit.run, l:end)
            call add(l:cmd, l:unit.cmd[i])
          endfor
          let l:unit.run = l:end
        endif
      endif
      try
        call execute(l:cmd, '')
      catch
        return s:Error(v:exception)
      endtry
    endif
  endif
  if !s:Board.timer | return | endif
  let l:unit.run += 1
  let s:Board.timer = timer_start(s:Board.interval, function('s:RunCmd'))
endfunction

" returns end index of the sentence, or -1 with error
function s:CheckSentence(unit, begin, match='')
  let l:length = len(a:unit.cmd)
  let l:index = a:begin
  while l:index < l:length
    let l:cmd = a:unit.cmd[l:index]
    for l:keyword in s:Sentence
      if stridx(a:unit.cmd[l:index][:8], l:keyword.' ') == 0
        let l:index = s:CheckSentence(a:unit, l:index+1, 'end'.l:keyword)
        if l:index == -1
          return -1
        endif
        let l:cmd = ''
        break
      endif
    endfor
    if empty(a:match) || l:cmd ==# a:match
      return l:index
    endif
    let l:index += 1
  endwhile
  let a:unit.error = 'Missing '.a:match
  return -1
endfunction

function s:Stop(status=1)
  if s:Board.timer
    call timer_stop(s:Board.timer)
    let s:Board.timer = 0
    if len(s:Board.stack)
      if a:status
        call s:Status('  '.s:Board.stack[-1].key.' stopped')
      endif
      let s:Board.stack = []
    endif
  endif
  return "\<Esc>"
endfunction

function s:Status(msg)
  call timer_start(0, {-> execute("echo '".a:msg."'", '')})
endfunction

function s:Warning(msg)
  redraw
  echohl WarningMsg | echo a:msg | echohl None
endfunction

function s:Error(msg)
  let s:Board.timer = 0
  let l:unit = s:Board.stack[-1]
  redraw
  echohl ErrorMsg
  echo  '  '.l:unit.key.'  '.l:unit.cmd[l:unit.run].'  '.a:msg.'  '
  echohl None
endfunction

function s:SetMenuExpand()
  let l:expand = get(g:,'BoardMenuExpand', 0)
  if l:expand && l:expand != s:Input.wait
    let s:Input.wait = min([max([l:expand, 180]), 480])
    let g:BoardMenuExpand = s:Input.wait
  endif
endfunction

function s:Prompt()
  call timer_start(0, function('s:InputLong'))
endfunction

function s:InputLong(...)
  let l:menu = ' Board (-)prev(=)main(+)new'
  let l:loaded = s:Loaded()
  if !l:loaded && get(b:,'BoardLinks', 0)
    let l:menu .= '(<)link'
  else
    if !&modified && l:loaded > 1
      setl nobl
    endif
  endif
  call s:SetColumn(1)
  call s:InputInit(1, l:menu.'  ')

  aug BoardCmdline
    au!
    au CmdlineLeave   * call s:CmdlineLeave(1)
    au CmdlineChanged * call s:CmdlineChanged(1)
  aug END
  cno <buffer><Space>     <Cmd>call <SID>Scroll('+')<CR><C-R><Esc>
  cno <buffer><C-Space>   <Cmd>call <SID>Scroll('-')<CR><C-R><Esc>
  cno <buffer><Nul>       <Cmd>call <SID>Scroll('-')<CR><C-R><Esc>
  cno <buffer><Down>      <Cmd>call <SID>Scroll('+')<CR><C-R><Esc>
  cno <buffer><Up>        <Cmd>call <SID>Scroll('-')<CR><C-R><Esc>
  cno <buffer><PageDown>  <Cmd>call <SID>Scroll('v')<CR><C-R><Esc>
  cno <buffer><PageUp>    <Cmd>call <SID>Scroll('^')<CR><C-R><Esc>
  cno <buffer><expr><C-C> <SID>Stop()
  cno <buffer><expr><CR>  <SID>Enter()
  cno <buffer><expr><C-J> <SID>Enter()
  exe 'cno <buffer>'.&cedit '<Nop>'

  call inputsave()
  echohl BoardGroup
  let l:key = trim(input(s:Board.menu))
  echohl None
  call inputrestore()
  echo ''

  if s:Board.enter
    if !empty(s:Board.input)
      let l:key = s:Board.input
    endif
    if empty(l:key)
      let s:Board.hold = s:Board.current
      setl bl
      return
    endif
  else
    let [l:key, s:Board.match] = [';', 0]
  endif

  if l:key == ':' || (!s:Board.match && stridx(s:Optional, l:key) != -1)
    let s:Board.hold = ''
    return feedkeys(l:key)
  elseif l:key == ';' && !s:Board.match
    let s:Board.hold = ''
    call s:Restore(1)
  elseif l:key == '<' && l:loaded
    setl bl
  else
    call s:Process(l:key)
  endif
endfunction

function s:InputShort()
  call s:InputInit(0, ' Board ')

  aug BoardCmdline
    au!
    au CmdlineLeave   * call s:CmdlineLeave(0)
    au CmdlineChanged * call s:CmdlineChanged(0)
  aug END
  cno <buffer><expr><C-C> <SID>Stop()
  cno <buffer><expr><C-J> <SID>Enter()
  cno <buffer><expr><CR>  <SID>Enter()
  cno <buffer><nowait><Esc> <Esc>
  exe 'cno <buffer>'.&cedit '<Nop>'

  let s:Input.reltime = reltime()
  let s:Input.timer = timer_start(s:Input.interval, function('s:InputCheck'))
  call inputsave()
  echohl BoardGroup
  let l:key = trim(input(s:Board.menu))
  echohl None
  call inputrestore()
  call timer_stop(s:Input.timer)
  let s:Input.timer = 0

  if s:Board.enter
    if !empty(s:Board.input)
      let l:key = s:Board.input
    endif
    if empty(l:key)
      let s:Board.hold = s:Board.current
      call s:Process('.')
      setl bl
      return
    endif
  else
    let [l:key, s:Board.match] = [';', 0]
  endif

  if l:key == ':' || (!s:Board.match && stridx(s:Optional, l:key) != -1)
    return feedkeys(l:key)
  else
    redraw | echo ''
    if l:key == '<' || (l:key == ';' && !s:Board.match)
      return
    else
      call s:Process(l:key)
    endif
  endif
endfunction

function s:InputInit(restore, menu)
  let s:Board.restore = a:restore
  let s:Board.input = ''
  let s:Board.change = ''
  let s:Board.keys = 0
  let s:Board.enter = 0
  let s:Board.match = 0
  let s:Board.menu = a:menu
endfunction

function s:InputCheck(...)
  if !s:Input.timer | return | endif
  if !s:Board.keys && empty(s:Board.change)
    let l:dt = reltimefloat(reltime(s:Input.reltime)) * 1000
    if l:dt >= s:Input.wait
      call feedkeys("\<Esc>", 'n')
      return timer_start(0, {-> execute("call s:Process('.?')")})
    endif
  else
    let s:Input.reltime = reltime()
  endif
  let s:Input.timer = timer_start(s:Input.interval, function('s:InputCheck'))
endfunction

function s:Edit()
  if search('_')
    exe "normal! r\<Space>"
  endif
endfunction

function s:SelectWin()
  if empty(get(t:, 'Board', ''))
    let t:Board = {'win': 0}
  endif

  let l:win = win_id2win(t:Board.win)
  if l:win && winnr() == bufwinnr(s:Board.scratch.pad)
    exe l:win "wincmd w"
  else
    if !empty(&buftype) && !&modifiable && index(['help', 'terminal'], &buftype) == -1
      for i in range(winnr('$'), 1, -1)
        let l:buf = winbufnr(i)
        if empty(getbufvar(l:buf, '&buftype')) || getbufvar(l:buf, '&modifiable')
          exe i "wincmd w"
          break
        endif
      endfor
    endif
  endif

  if &filetype != 'board' && !empty(bufname())
    let w:BoardOverlap = {'buf':bufnr(), 'view':winsaveview()}
  endif
  let t:Board.win = win_getid()
endfunction

function s:ConfirmSave()
  echohl BoardMarker
  echo "  Save changes? (y)es, (n)o: "
  echohl None
  let l:op = nr2char(getchar())
  echo ''
  redraw
  if l:op ==? 'y'
    update
  endif
  return !&modified
endfunction

function s:CmdlineLeave(board)
  if exists("#BoardCmdline")
    au!  BoardCmdline
    aug! BoardCmdline
  endif
  if a:board
    cmapclear <buffer>
  else
    cu <buffer><C-C>
    cu <buffer><CR>
    cu <buffer><Esc>
    exe 'cu <buffer>'.&cedit
  endif
  call s:Help.Update(0)
endfunction

function s:CmdlineChanged(board)
  let s:Input.reltime = reltime()
  if s:FindKey(getcmdline())
    let s:Board.enter = 1
    call feedkeys("\<Esc>", 'n')
  endif
endfunction

function s:OpenScratchpad()
  let l:buf = s:Board.scratch.pad
  if !bufexists(l:buf)
    let l:buf = -1
    let s:Board.scratch.pad = bufadd(s:Board.scratch.name)
    call bufload(s:Board.scratch.pad)
  endif
  let l:win = bufwinnr(s:Board.scratch.pad)
  if l:win == -1
    exe "bel sb" s:Board.scratch.pad
    exe "resize" (winheight(0)/2 + 1)
  else
    exe l:win "wincmd w"
  endif
  if l:buf == -1
    setl buftype=nofile bl noswapfile nofen nowrap nonu
  endif
  normal! G
endfunction

function s:Scroll(key)
  if has_key(s:KeyMap, a:key)
    exe "normal! ".s:KeyMap[a:key].'M'
    redraw
  endif
endfunction

function s:Enter()
  let s:Board.enter = 1
  return "\<CR>"
endfunction

function s:FindKey(key)
  if s:Board.change ==# a:key | return | endif
  let s:Board.change = a:key
  let s:Board.input = ''
  let s:Board.keys = 0
  let s:Board.match = 0
  let l:len = len(a:key)
  let l:help = ''
  if (l:len == 1 && stridx('-=+:<>', a:key) != -1)
    let s:Board.input = a:key
    let s:Board.keys = 1
    return 1
  elseif l:len
    let s:Board.keys = 1
    let l:list = s:GetKeys(a:key)
    let s:Board.match = len(l:list)
    if !s:Board.match && l:len == 1 && stridx(s:Optional.";", a:key) != -1
      let s:Board.input = a:key
      return 1
    elseif s:Board.match == 1
      if a:key == l:list[0]
        return 1
      endif
      let s:Board.input = l:list[0]
    endif
    let l:help = join(l:list, '  ')
    let l:left = max([len(s:Board.menu) - len(l:help)/2 + 1, 7])
    let l:help = repeat(' ', l:left).l:help
  endif
  call s:Help.Update(1, l:help)
endfunction

function s:BufReadPost()
  call s:ClearSyntaxGuide()
endfunction

function s:BufWritePost()
  if s:Loaded()
    call s:LoadLinks()
  else
    call s:CheckLinks(1)
  endif
endfunction

function s:ColorScheme()
  call s:LoadColors()
endfunction

function board#Load()
  call s:SetBoard()
  if exists("s:Ready") | return | endif

  call s:LoadColors()
  if exists("*popup_create")
    let s:Help.Update = function('s:WinPopup')
  elseif exists("*nvim_open_win")
    let s:Help.Update = function('s:WinFloat')
  else
    let s:Help.Update = function('s:Nop')
  endif
  let s:Ready = 1
  aug Board
    au!
    au BufReadPost  *.board,*.bd call <SID>BufReadPost()
    au BufWritePost *.board,*.bd call <SID>BufWritePost()
    au ColorScheme  * call <SID>ColorScheme()
  aug END
  call s:BufReadPost()
endfunction

function board#Menu()
  let l:buf = bufname()
  if l:buf == '[Command Line]' | return | endif
  let l:reg = g:BoardRegister[0]
  let l:board = s:BoardFile(l:buf)
  if match(l:reg, '[a-z]') != -1
    call setreg(l:reg, fnamemodify(l:buf, ':~'))
  endif
  if !s:Loaded() && l:board
    call s:SetOrder(fnamemodify(l:buf, ':p'))
  endif
  if empty(s:Board.main)
    call s:SetMainBoard()
  elseif l:board
    call s:Process('.?')
  else
    call s:SetMenuExpand()
    call s:InputShort()
  endif
endfunction

function board#TermCd()
  let l:op = has('win32') ? '/d ' : ''
  let l:cd = 'cd '.l:op.fnamemodify(getcwd(), ':~')->escape(' ')."\<CR>"
  if exists("*term_sendkeys")
    call term_sendkeys(bufnr(), l:cd)
  elseif exists("*chansend")
    call chansend(b:terminal_job_id, l:cd)
  endif
endfunction

function board#Complete(arg, line, pos)
  let l:cmd = ['speed ','stack ','start ','stop','menu']
  return filter(l:cmd, {i,v -> match(v, '^'.a:arg) == 0})
endfunction

function board#Command(cmd)
  let l:arg = split(a:cmd)
  let l:cmd = substitute(get(l:arg, 0, ''), '\v^:', '', '')
  let l:val = get(l:arg, 1, '')

  if     l:cmd ==# ''      | echo ' Board version '.s:Version
  elseif l:cmd ==# '*'     | call s:OpenScratchpad()
  elseif l:cmd ==? 'speed' | call s:SetSpeed(l:val)
  elseif l:cmd ==? 'stack' | call s:SetStack(l:val)
  elseif l:cmd ==? 'start' | call s:AddLink(l:val)
  elseif l:cmd ==? 'stop'  | call s:Stop(0)
  elseif l:cmd ==? 'menu'  | call board#Menu()
  else
    echo ' Board: no matching command: '.l:cmd
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
