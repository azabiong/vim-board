" board file syntax
"
"  comment: #
"  special: *+=&?!
"    plain: -
" surround: [] {} <> ``
"  section: column 1
"    group: column 2~5
"     text: column 6~

if exists("b:current_syntax")
  finish
endif

syn region BoardBlock start="^[^#:\- ]" end="$\n^[^# ]"me=e-1 transparent contains=
  \ BoardSection,BoardGroup,BoardMarker,BoardLed1,BoardLed2,BoardLed3,BoardComment,BoardText,BoardPlain,
  \ BoardSpecial,BoardPlus,BoardEqual,BoardColon,BoardAmpersand,BoardQuestion,BoardExclamation,BoardEmpty

syn region BoardConfig start="^[:]" end="$\n^[^# ]"me=e-1 transparent contains=
  \ BoardCfgType,BoardCfgLinks,BoardLink,BoardGroup,BoardMarker,BoardCommentLine,BoardPlain,
  \ BoardSpecial,BoardPlus,BoardEqual,BoardColon,BoardAmpersand,BoardQuestion,BoardExclamation,BoardEmpty

syn match BoardSection "^[^#:\- ].*$" contained contains=BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardComment
syn match BoardCfgType "\v^:\S.*$" contained contains=BoardComment
syn match BoardGroup "\v^[|: ]\s{1,3}\S.*$" contained contains=BoardGuide,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardComment
syn match BoardText "\v^[|: ]\s{4,}\S.*$" contained contains=BoardGuide,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardComment
syn match BoardSpecial "^[|:]\?\s*\*.*$" contained contains=BoardGuide,BoardMarker,BoardComment
syn match BoardPlus "^[|:]\?\s*+.*$" contained contains=BoardGuide,BoardMarker,BoardComment
syn match BoardEqual "^[|:]\?\s*=.*$" contained contains=BoardGuide,BoardMarker,BoardComment
syn match BoardColon "^[|:]\?\s\+:.*$" contained contains=BoardGuide,BoardMarker,BoardComment
syn match BoardAmpersand "^[|:]\?\s*&.*$" contained contains=BoardGuide,BoardMarker,BoardComment
syn match BoardQuestion "^[|:]\?\s*?.*$" contained contains=BoardGuide,BoardMarker,BoardComment
syn match BoardExclamation "^[|:]\?\s*!.*$" contained contains=BoardGuide,BoardMarker,BoardComment
syn match BoardLink "\v^[: ]\s{4,}\S.*$" contained contains=BoardGuide,BoardJumper
syn match BoardLed1 "\[[^]]*]" contained contains=BoardBracket
syn match BoardLed2 "{[^}]*}" contained contains=BoardBracket
syn match BoardLed3 "\v\<[^\>]*\>" contained contains=BoardBracket
syn match BoardEmpty "^[|:]\s*$" contained contains=BoardGuide
syn match BoardGuide "^[|:]" contained
syn match BoardBracket "[\[\]\{\}\<\>]" contained
syn match BoardMarker "`[^`]*`" contained
syn match BoardTodo "\<Todo\>\c" contained
syn match BoardJumper " \zs[|&]:\=" contained
syn match BoardComment "#.*$" contained contains=BoardTodo
syn match BoardCommentLine "^:\?\s*#.*$" contains=BoardGuide,BoardComment

syn match BoardPlain "^[|:]\?\s*-.*$" contains=BoardGuide

hi def link BoardHelp StatusLine
hi def link BoardSpecial WarningMsg
hi def link BoardColon String
hi def link BoardPlus Label
hi def link BoardEqual Keyword
hi def link BoardAmpersand MoreMsg
hi def link BoardQuestion Question
hi def link BoardExclamation Constant
hi def link BoardCfgType PreProc
hi def link BoardLink Type
hi def link BoardGuide Comment
hi def link BoardComment Comment
hi def link BoardJumper Operator
hi def link BoardTodo Todo

set cms=#%s
let b:current_syntax = "board"
