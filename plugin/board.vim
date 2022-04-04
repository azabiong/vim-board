" Vim Board: Multifunction writable board
" Author: Azabiong
" License: MIT
" Source: https://github.com/azabiong/vim-board
" Version: 1.03

scriptencoding utf-8
if exists("g:loaded_vim_board")
  finish
endif
if !has('timers')
  echoe ' vim-board: plugin uses features of Vim version 8.2 or higher'
  finish
endif
let g:loaded_vim_board = 1

nn <Plug>(BoardMenu) <Cmd>call board#Menu()<CR>

if !hasmapto('<Plug>(BoardMenu)', 'n') && empty(maparg("'<Space>", 'n'))
  nmap '<Space> <Plug>(BoardMenu)
endif

command! -complete=customlist,board#Complete -nargs=* Board call board#Command(<q-args>)

