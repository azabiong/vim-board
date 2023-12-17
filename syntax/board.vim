" board file syntax
"
"  comment: #
"  special: *+=&?!:
"    plain: -
" surround: [] {} <> ``
"  section: column 1
"    group: column 2~5
"     text: column 6~
"    brief: :

if exists("b:current_syntax")
  finish
endif

syn region BoardBlock start="^[^#:\- ]" end="$\n^[^# ]"me=e-1 transparent contains=
  \ BoardSection,BoardGroup,BoardMarker,BoardLed1,BoardLed2,BoardLed3,BoardComment,BoardText,BoardPlain,
  \ BoardSpecial,BoardPlus,BoardEqual,BoardColon,BoardAmpersand,BoardQuestion,BoardExclamation,BoardEmpty

syn region BoardConfig start="^[:]" end="$\n^[^# ]"me=e-1 transparent contains=
  \ BoardCfgType,BoardCfgLinks,BoardLink,BoardGroup,BoardMarker,BoardComment,BoardPlain,
  \ BoardSpecial,BoardPlus,BoardEqual,BoardColon,BoardAmpersand,BoardQuestion,BoardExclamation,BoardEmpty

syn match BoardSection "^[^#:\- ].*$" contained contains=BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardGroup "\v^[|: ] {,3}\S.*$" contained contains=BoardGuide,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardText "\v^[|: ] {4,}\S.*$" contained contains=BoardGuide,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardComment
syn match BoardCfgType "\v^:\S.*$" contained contains=BoardBrief,BoardComment
syn match BoardSpecial "^[|:]\?\s*\*.*$" contained contains=BoardGuide,BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardPlus "^[|:]\?\s*+.*$" contained contains=BoardGuide,BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardEqual "^[|:]\?\s*=.*$" contained contains=BoardGuide,BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardColon "^[|:]\?\s\+:.*$" contained contains=BoardGuide,BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardAmpersand "^[|:]\?\s*&.*$" contained contains=BoardGuide,BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardQuestion "^[|:]\?\s*?.*$" contained contains=BoardGuide,BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardExclamation "^[|:]\?\s*!.*$" contained contains=BoardGuide,BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardBrief,BoardComment
syn match BoardBrief " :.*$" contained contains=BoardSign,BoardLed1,BoardLed2,BoardLed3,BoardMarker,BoardComment
syn match BoardLink "\v^[: ] {4,}\S.*$" contained contains=BoardGuide,BoardJumper
syn match BoardEmpty "^[|:]\s*$" contained contains=BoardGuide
syn match BoardLed1 "\[[^]]*]" contained contains=BoardBracket
syn match BoardLed2 "{[^}]*}" contained contains=BoardBracket
syn match BoardLed3 "\v\<[^\>]*\>" contained contains=BoardBracket
syn match BoardMarker "`[^`]*`" contained contains=BoardBacktick
syn match BoardBracket "[\[\]\{\}\<\>]" contained
syn match BoardSign "\v(^\s*[*+=&?!:]| :)" contained
syn match BoardBacktick "`" contained
syn match BoardGuide "^[|:]" contained
syn match BoardTodo "\<Todo\>\c" contained
syn match BoardJumper " \zs[|&]:\=" contained
syn match BoardPlain "^[|:]\?\s*-.*$" contains=BoardGuide
syn match BoardComment "\v(^[|:]? *| +)#.*$" contained contains=BoardGuide,BoardTodo
syn match BoardCommentLine "^\s*#.*$"

syn sync minlines=256

hi def link BoardHelp StatusLine
hi def link BoardCfgType PreProc
hi def link BoardJumper Operator
hi def link BoardSign BoardGuide
hi def link BoardBacktick BoardGuide
hi def link BoardTodo Todo
hi def link BoardComment Comment
hi def link BoardCommentLine Comment
hi def link BoardBrief Statement

set cms=#%s
let b:current_syntax = "board"
