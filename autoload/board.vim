" Vim Board: Multifunction writable board
" Author: Azabiong
" License: MIT
" Source: https://github.com/azabiong/vim-board
" Version: 0.9

scriptencoding utf-8
if exists("s:Board")
  finish
endif
let s:cpo_save = &cpo
set cpo&vim

let g:BoardRegister = get(g:,'BoardRegister','b')

let s:Version = '0.9'
let s:Board = #{ plug:expand('<sfile>:h'), path:'', main:'', current:'', prev:'',
               \ opened:'', menu:0, input:'', enter:0,
               \ timer:0, interval:10, stack:[#{key:'', cmd:[], run:0}], range:1024,
               \ }
let s:Links  = {'bufnr':{'key':'path'}, 'order':[]}
let s:KeyMap = {'+':"4\<C-E>", '-':"4\<C-Y>", 'v':"\<C-F>", '^':"\<C-B>"}
let s:Help   = {'Update':'', 'win':0, 'buf':-1}
let s:Sentence = ['if', 'for', 'while']

aug Board
  au!
  au BufRead,BufNewFile *.board set ft=board
  au BufWritePost       *.board call <SID>BufWritePost()
  au BufReadPost        *.board call <SID>BufReadPost()
  au ColorScheme        *       call <SID>ColorScheme()
aug END

function s:Load()
  if exists("s:Colors") | return | endif

  call s:LoadColors()
  if exists("*popup_create")
    let s:Help.Update = function('s:WinPopup')
  elseif exists("*nvim_open_win")
    let s:Help.Update = function('s:WinFloat')
  else
    let s:Help.Update = function('s:Nop')
  endif
endfunction

function s:LoadColors()
  if has('gui_running') || (has('termguicolors') && &termguicolors) || &t_Co >= 256
    if &background == 'dark'
      let s:Colors = [
        \ ['BoardSection', 'ctermfg=219 ctermbg=NONE cterm=bold guifg=#f8a0f8 guibg=NONE    gui=bold'],
        \ ['BoardConfig',  'ctermfg=109 ctermbg=NONE cterm=NONE guifg=#92b6b4 guibg=NONE    gui=NONE'],
        \ ['BoardGroup',   'ctermfg=147 ctermbg=NONE cterm=bold guifg=#aabcf0 guibg=NONE    gui=bold'],
        \ ['BoardLed1',    'ctermfg=159 ctermbg=60   cterm=NONE guifg=#a0f0f0 guibg=#585888 gui=NONE'],
        \ ['BoardLed2',    'ctermfg=225 ctermbg=96   cterm=NONE guifg=#f8d8f8 guibg=#905080 gui=NONE'],
        \ ['BoardLed3',    'ctermfg=229 ctermbg=240  cterm=NONE guifg=#f0f0a8 guibg=#686040 gui=NONE'],
        \ ['BoardBracket', 'ctermfg=243 ctermbg=238  cterm=NONE guifg=#787a78 guibg=#404242 gui=NONE'],
        \ ['BoardMarker',  'ctermfg=114 ctermbg=NONE cterm=bold guifg=#88c888 guibg=NONE    gui=bold'],
        \ ['BoardLink',    'ctermfg=215 ctermbg=NONE cterm=bold guifg=#f8b868 guibg=NONE    gui=bold'],
        \ ]
    else
      let s:Colors = [
        \ ['BoardSection', 'ctermfg=127 ctermbg=NONE cterm=bold guifg=#af00af guibg=NONE    gui=bold'],
        \ ['BoardConfig',  'ctermfg=61  ctermbg=NONE cterm=NONE guifg=#5040a8 guibg=NONE    gui=NONE'],
        \ ['BoardGroup',   'ctermfg=25  ctermbg=NONE cterm=bold guifg=#2a58b0 guibg=NONE    gui=bold'],
        \ ['BoardLed1',    'ctermfg=18  ctermbg=195  cterm=NONE guifg=#000078 guibg=#d8f8f8 gui=NONE'],
        \ ['BoardLed2',    'ctermfg=88  ctermbg=225  cterm=NONE guifg=#780000 guibg=#fcd8fa gui=NONE'],
        \ ['BoardLed3',    'ctermfg=234 ctermbg=230  cterm=NONE guifg=#282800 guibg=#f8f8d8 gui=NONE'],
        \ ['BoardBracket', 'ctermfg=248 ctermbg=188  cterm=NONE guifg=#a8a8a8 guibg=#d8d8d8 gui=NONE'],
        \ ['BoardMarker',  'ctermfg=28  ctermbg=NONE cterm=bold guifg=#008000 guibg=NONE    gui=bold'],
        \ ['BoardLink',    'ctermfg=166 ctermbg=NONE cterm=bold guifg=#d85820 guibg=NONE    gui=bold'],
        \ ]
    endif
  else
      let s:Colors = [
        \ ['BoardSection', 'ctermfg=Magenta'],
        \ ['BoardConfig',  'ctermfg=Blue'   ],
        \ ['BoardGroup',   'ctermfg=Cyan'   ],
        \ ['BoardLed1',    'ctermfg=White ctermbg=darkCyan'   ],
        \ ['BoardLed2',    'ctermfg=White ctermbg=darkMagenta'],
        \ ['BoardLed3',    'ctermfg=White ctermbg=darkYellow' ],
        \ ['BoardMarker',  'ctermfg=Green'  ],
        \ ['BoardLink',    'ctermfg=Red'    ],
        \ ]
  endif
  for l:c in s:Colors
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
  let l:vim = (match(s:Board.plug, '/vimfiles') != -1) ? 'vimfiles' : '.vim'
  let l:main = expand('$HOME').'/'.l:vim.'/after/vim-board'
  let l:main = expand(get(g:, 'BoardPath', l:main)).'/_main_.board'
  let l:edit = ''
  if !filereadable(l:main)
    let l:edit = " main board:  ".fnamemodify(l:main, ':~')."\n"
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
    let s:Board.opened = ''
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
  let l:file = trim(input('  New board name: '))
  echohl None
  echo ''
  if empty(l:file) | return | endif

  let l:file = (l:file =~ '\.board$') ? l:file : l:file.'.board'
  let l:file = s:Board.path.'/'.l:file
  if !filereadable(l:file)
    exe "edit" l:file
    %delete
    let l:base = s:Board.plug.'/_new'
    silent exe "0read" l:base
    silent exe "bwipe" l:base
    call setline(1, '# '.fnamemodify(l:file, ':t'))
  endif
  call s:OpenFile(l:file, 2)
  call s:Edit()
  echo ''
endfunction

function s:Switch(key)
  let l:board = []  " [board, load]
  let l:current = (&filetype == 'board') ? expand('%:p') : s:Board.current

  if     a:key == '+' | return s:AddNewBoard()
  elseif empty(a:key) | let l:board = [l:current, 0]
  elseif a:key == '-' | let l:board = [s:Board.prev, 0]
  elseif a:key == '=' | let l:board = [s:Board.main, 2]
  elseif a:key == '=='| let l:board = [l:current, 1]
                        if &modified && !s:ConfirmSave()
                          return s:Prompt()
                        endif
  endif
  if !empty(l:board)
    call s:OpenFile(l:board[0], l:board[1])
    return s:Prompt()
  else
    if s:Board.timer
      call timer_stop(s:Board.timer)
    endif
    let s:Board.stack = []
    let s:Board.range = 1024
    let s:Board.interval = 10
    call s:RunLink(a:key)
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
  elseif isdirectory(l:path)
    if &lazyredraw | redraw | endif
    exe "cd" l:path
    call s:OpenFile(s:Board.opened)
    echohl BoardGroup | echo ' '.l:info | echohl None
  else
    if filereadable(l:path)
      let l:path = fnamemodify(l:path, ':p')
    else
      let l:path = s:Board.path.'/'.l:path
      if !filereadable(l:path)
        call s:Warning(' * Path not found  '.l:info.' ('.l:link.board.'  '.a:key.')')
        return 0
      endif
    endif
    if fnamemodify(l:path, ':e') ==? 'board'
      call s:SelectWin()
      if s:OpenFile(l:path, 2) && l:base
        call s:Prompt()
      endif
      return 1
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
  let l:key = matchstr(a:key, '&\?\zs\w\+')
  return s:RunLink(l:key)
endfunction

function s:OpenFile(path, load=0)
  let l:buf = bufnr(a:path)
  if !filereadable(a:path) && l:buf == -1 | return | endif
  if l:buf == -1
    exe "edit" a:path
  else
    exe "buf" l:buf
  endif
  if fnamemodify(a:path, ':e') ==? 'board'
    call s:SetOrder(a:path)
    if a:load
      call s:SetBoard()
      if !s:Loaded()
        call s:LoadLinks(a:path, a:load)
      endif
    endif
  endif
  redraw
  return 1
endfunction

" return {board, path, command[]}
function s:GetLink(key)
  for b in s:Links.order
    if has_key(s:Links, b) && has_key(s:Links[b], a:key)
      let l:line = s:Links[b][a:key]
      if l:line[0] == '|'
        let l:line = '| '.l:line
      endif
      let l:list = map(split(l:line, '|'), {i,v -> trim(v)})
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
    call filter(s:Links.order, {i,v -> v != l:bufnr})
    call insert(s:Links.order, l:bufnr)
  endif
endfunction

function s:Loaded()
  if exists("b:Board")
    return 1 + b:Board.list
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
  let l:pos = getpos('.')
  if !filereadable(l:board) || !search('^:Links\c\>', 'w')
    return
  endif
  let l:bufnr = bufnr(l:board)
  let s:Links[l:bufnr] = {}
  let l:list = s:Links[l:bufnr]
  let l:list['#'.l:bufnr] = fnamemodify(l:board, ':t')
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
  call s:SetSyntax(0)
  call setpos('.', l:pos)
endfunction

" return [] end_of_section,  [''] no_value,  ['key','path|cmd|cmd..']
function s:ReadLine(num)
  let l:line = getline(a:num)
  " section column 1
  if !empty(line[0]) && stridx('# ', line[0]) == -1
    return []
  endif
  " key column > 5
  if match(l:line, '\v\ {5,}\S') != -1
    let l:line = trim(l:line)
    if stridx('#*`-=+;:.', line[0]) == -1
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

function s:SetBoard()
  if &ft !=# 'board'
    setl ft=board ts=4 sts=4 sw=0
  endif
  setl nonu
endfunction

function s:SetSyntax(op)
  if a:op || !exists("b:Board.syntax")
    syn match BoardLink "^:links\c\>" contained
    let b:Board.syntax = 'on'
  endif
  setl fdm=marker nonu
endfunction

function s:SetSpeed(freq)
  let s:Board.interval = (a:freq ==? 'max') ? 0 : 1000 / min([max([a:freq, 1]), 1000])
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
    if match(l:cmd, '^\S\+\.board$\c') == 0
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

" return end index of the sentence, or -1 with error
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
    if empty(a:match)
      return l:index
    elseif l:cmd ==# a:match
      return l:index
    endif
    let l:index += 1
  endwhile
  let a:unit.error = 'Missing '.a:match
  return -1
endfunction

function s:Stop()
  if s:Board.timer
    call timer_stop(s:Board.timer)
    let s:Board.timer = 0
    if len(s:Board.stack)
      call s:Status('  Stopped  '.s:Board.stack[-1].key)
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

function s:Prompt()
  call timer_start(0, function('s:Input'))
endfunction

function s:Input(...)
  let s:Board.input = ''
  let s:Board.enter = 0
  let l:menu = ' Board (-)prev(=)main(+)new(;)return'
  let l:loaded = s:Loaded()
  if !l:loaded
    let l:menu .= '(.)load'
  else
    if !&modified && l:loaded > 1
     setl nobl
   endif
   setl nonu
  endif
  let s:Board.menu = l:menu.'  '

  aug BoardCmdline
    au!
    au CmdlineLeave   * call s:CmdlineLeave()
    au CmdlineChanged * call s:CmdlineChanged()
  aug END
  cno <buffer><Space>    <Cmd>call <SID>Scroll('+')<CR><C-R><Esc>
  cno <buffer><C-Space>  <Cmd>call <SID>Scroll('-')<CR><C-R><Esc>
  cno <buffer><Nul>      <Cmd>call <SID>Scroll('-')<CR><C-R><Esc>
  cno <buffer><Down>     <Cmd>call <SID>Scroll('+')<CR><C-R><Esc>
  cno <buffer><Up>       <Cmd>call <SID>Scroll('-')<CR><C-R><Esc>
  cno <buffer><PageDown> <Cmd>call <SID>Scroll('v')<CR><C-R><Esc>
  cno <buffer><PageUp>   <Cmd>call <SID>Scroll('^')<CR><C-R><Esc>
  cno <buffer><expr><CR> <SID>Enter()
  cno <buffer><expr><C-C> <SID>Stop()

  call inputsave()
  echohl BoardGroup
  let l:key = trim(input(s:Board.menu))
  echohl None
  call inputrestore()
  echo ''
  if s:Board.enter && !empty(s:Board.input)
    let l:key = s:Board.input
  endif
  if empty(l:key)
    if s:Board.enter
      setl bl
      return
    endif
    let l:key = ';'
  endif

  if l:key == ";"
    let l:buf = bufname()
    if !empty(s:Board.opened) && s:Board.opened != fnamemodify(l:buf, ':p')
      call s:OpenFile(s:Board.opened)
    endif
  elseif l:key == ':'
    return feedkeys(':', 'n')
  elseif l:key == '.'
    if !l:loaded
      call s:Switch('==')
    else
      setl bl
    endif
  else
    call s:Switch(l:key)
  endif
endfunction

function s:Edit()
  if search('_')
    exe "normal! r\<Space>"
  endif
endfunction

function s:SelectWin()
  if !empty(&buftype)
    for i in range(winnr('$'), 1, -1)
      if empty(winbufnr(i)->getbufvar('&buftype'))
        exe i "wincmd w"
        break
      endif
    endfor
  endif
endfunction

function s:CmdlineLeave()
  if exists("#BoardCmdline")
    au!  BoardCmdline
    aug! BoardCmdline
  endif
  cmapclear <buffer>
  call s:Help.Update(0)
endfunction

function s:CmdlineChanged()
  if s:FindKey(getcmdline())
    let s:Board.enter = 1
    call feedkeys("\<Esc>", 'n')
  endif
endfunction

function s:Scroll(key)
  if has_key(s:KeyMap, a:key)
    exe "normal! ".s:KeyMap[a:key]
    redraw
  endif
endfunction

function s:Enter()
  let s:Board.enter = 1
  return "\<CR>"
endfunction

function s:FindKey(key)
  let s:Board.input = ''
  let l:len = len(a:key)
  let l:help = ''
  if l:len == 1 && stridx('-=+;:.', a:key) != -1
    let s:Board.input = a:key
    return 1
  elseif l:len
    let l:list = s:GetKeys(a:key)
    let l:len = len(l:list)
    if l:len == 1
      if a:key == l:list[0]
        return 1
      endif
      let s:Board.input = l:list[0]
    endif
    let l:help = join(l:list, '  ')
    let l:left = max([len(s:Board.menu) - len(l:help)/2 + 1, 8])
    let l:help = repeat(' ', l:left).l:help
  endif
  call s:Help.Update(1, l:help)
endfunction

function s:BufWritePost()
  if s:Loaded()
    call s:LoadLinks()
  endif
endfunction

function s:BufReadPost()
  if s:Loaded()
    call s:SetSyntax(1)
  endif
endfunction

function s:ConfirmSave()
  echohl BoardMarker
  echo "  Save changes? (y)es, (n)o: "
  echohl None
  let l:op = getcharstr()
  echo ''
  redraw
  if l:op ==? 'y'
    update
  endif
  return !&modified
endfunction

function s:ColorScheme()
  call s:LoadColors()
endfunction

function board#Menu()
  call s:SelectWin()
  let l:reg = g:BoardRegister[0]
  if match(l:reg, '[a-z]') != -1
    call setreg(l:reg, fnamemodify(bufname(), ':~'))
  endif
  if !s:Loaded()
    let s:Board.opened = fnamemodify(bufname(), ':p')
    if fnamemodify(bufname(), ':e') ==? 'board'
      call s:SetOrder(s:Board.opened)
    endif
  endif
  if empty(s:Board.main)
    call s:SetMainBoard()
    return
  endif
  call s:Switch('')
endfunction

function board#Complete(arg, line, pos)
  let l:cmd = ['speed ','stack ','start ','stop']
  return filter(l:cmd, {i,v -> match(v, '^'.a:arg) == 0})
endfunction

function board#Command(cmd)
  let l:arg = split(a:cmd)
  let l:cmd = substitute(get(l:arg, 0, ''), '\v^:', '', '')
  let l:val = get(l:arg, 1, '')

  if     l:cmd ==# ''      | echo ' Board version '.s:Version
  elseif l:cmd ==? 'speed' | call s:SetSpeed(l:val)
  elseif l:cmd ==? 'stack' | call s:SetStack(l:val)
  elseif l:cmd ==? 'start' | call s:AddLink(l:val)
  elseif l:cmd ==? 'stop'  | call s:Stop()
  else
    echo ' Board: no matching command: '.l:cmd
  endif
endfunction

call s:Load()

let &cpo = s:cpo_save
unlet s:cpo_save