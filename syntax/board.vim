" board file syntax
"
"  comment: #
"  special: *+=&
"    plain: -
" surround: [] {} <> ``
"  section: column 1
"    group: column 2~5
"     text: column 6~

if exists("b:current_syntax")
  finish
endif

syn region boardRegion start="^[^#:\- ]\+" end="$\n^[^# ]"me=e-1 transparent contains=
  \ BoardSection,BoardGroup,BoardLed1,BoardMarker,BoardLed2,BoardLed3,BoardComment,
  \ BoardSpecial,BoardPlain,BoardEqual,BoardPlus,BoardAmpersand

syn region BoardConfig start="^:" end="$\n^[^# ]"me=e-1 contains=
  \ BoardConfig,BoardLink,BoardGroup,BoardMarker,BoardJumper,BoardComment,
  \ BoardSpecial,BoardPlain,BoardEqual,BoardPlus,BoardAmpersand

syn match BoardSection "^\S.*$" contained contains=BoardLed1,BoardLed2,BoardLed3,BoardMarker
syn match BoardGroup "\v^\s{1,4}\S.*$" contained contains=BoardLed1,BoardLed2,BoardLed3,BoardMarker
syn match BoardSpecial "^\s*\*.*$" contained contains=BoardMarker
syn match BoardPlus "^\s*+.*$" contained contains=BoardMarker
syn match BoardEqual "^\s*=.*$" contained contains=BoardMarker
syn match BoardAmpersand "^\s*&.*$" contained contains=BoardMarker
syn match BoardLed1 "\[[^]]*]" contained contains=BoardBracket
syn match BoardLed2 "{[^}]*}" contained contains=BoardBracket
syn match BoardLed3 "\v\<[^\>]*\>" contained contains=BoardBracket
syn match BoardComment "^\s*#.*$" contains=BoardTodo
syn match BoardBracket "[\[\]\{\}\<\>]" contained
syn match BoardMarker "`[^`]*`" contained
syn match BoardConfig "\v^:.*$" contained
syn match BoardTodo "\<Todo\>\c" contained
syn match BoardJumper " \zs[|&]:\=" contained
syn match BoardPlain "^\s*-.*$"

hi def link BoardHelp    StatusLine
hi def link BoardSpecial WarningMsg
hi def link BoardPlus    Label
hi def link BoardEqual   Keyword
hi def link BoardAmpersand Question
hi def link BoardConfig  Type
hi def link BoardComment Comment
hi def link BoardJumper  Operator
hi def link BoardTodo    Todo

set cms=#%s
let b:current_syntax = "board"
