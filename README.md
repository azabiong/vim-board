<!-- https://github.com/azabiong/vim-board -->

# vim-board

<p><h6> &nbsp;&nbsp; ver 1.25 </h6></p>

This plugin introduces a file type `board` where you can write quick notes and some shortcuts to
files, directories and additional commands.

### Feature

> After setting a custom `Key`, you can use the following key sequence to bring up the board:
>
> &nbsp; &nbsp; &nbsp; `Key` <kbd>Enter</kbd>
>
> and to return:
>
> &nbsp; &nbsp; &nbsp; `Key` <kbd>Esc</kbd>

<br>

## Installation

You can use your preferred plugin manager using the string `'azabiong/vim-board'`. For example:
```vim
 Plug 'azabiong/vim-board'
```
<details>
<summary>&nbsp; or,&nbsp; Vim's built-in package feature: </summary>
<br>

> |Linux, Mac| Windows &nbsp;|
> |:--:|--|
> |~/.vim| ~/vimfiles|
>
> in the terminal:
> ```zsh
> cd ~/.vim && git clone --depth=1 https://github.com/azabiong/vim-board.git pack/azabiong/start/vim-board
> cd ~/.vim && vim -u NONE -c "helptags pack/azabiong/start/vim-board/doc" -c q
> ```
</details>
<br>

## Configuration

The first step is to define a directory to store the `board` files. The plugin default path is:
```vim
    let BoardPath = '~/.vim/after/vim-board'
```
The next step is to assign a convenient key to bring up the `menu` with the `board`. The plugin
default shortcut is a single quote and space if available.
```vim
    nmap '<Space> <Plug>(BoardMenu)
```

<details>
<summary><b>&nbsp; lua </b></summary>

```lua
  vim.g.BoardPath = '~/.vim/after/vim-board'

  vim.keymap.set('n', "'<Space>", '<Plug>(BoardMenu)')
```
</details>

Now, save the changes and reload the plugin.


<br>

## Syntax

The plugin has an easy syntax and uses `.board` and `.bd` as file extensions.  
You can display each item differently by using indentation and some leading characters.

<div style="display:inline-block">
<img width="315" alt="board_light" src="https://user-images.githubusercontent.com/83812658/209437944-cdfc79bc-819b-4b38-9cf6-71edb80c0eff.png">
<img width="315" alt="board_dark" src="https://user-images.githubusercontent.com/83812658/209437963-67ea4c14-1da6-40b0-939e-dfa4e6981ad6.png">
</div><br>

### Section

The plugin uses sections to categorize content. Each section starts at the beginning of a line,
and can have different syntax depending on its type.

<br>

## Menu

Pressing the `BoardMenu` key will bring up the auto-expanding menu with the most recently used `board`.

<img height="26" alt="menu" src="https://github.com/azabiong/vim-board/assets/83812658/b3958bdf-f6b9-4f2c-84f0-6de6054ad35b">

You can enter keys defined on the `board`, or switch between boards using the following keys:

<details>
<summary><b> keys </b></summary>
<br>

  |key|function|
  |:--:|:--|
  |<kbd>Enter</kbd>|edit current board|
  |<kbd>Esc</kbd>  |return|
  |<kbd>;</kbd>    |return (optional)|
  |<kbd>Space</kbd>|scroll down|
  |<kbd>↓</kbd>    |scroll down|
  |<kbd>↑</kbd>    |scroll up|
  |<kbd>Ctrl</kbd><kbd>Space</kbd> |scroll up|
  |<kbd>-</kbd>    |switch to previous board|
  |<kbd>=</kbd>    |switch to main board|
  |<kbd>+</kbd>    |add new board|
  |<kbd>:</kbd>    |command-line mode|
  |<kbd>/</kbd>    |search (optional)|
  |<kbd><</kbd>    |load links|
  |<kbd>></kbd>    |unload links|

</details>
<br>

## :Links Section

 The plugin loads the shortcut links defined in this section. The following example defines
 two links:
 ```
 :Links
        \py  ~/Languages/Python/
         pn  ~/Languages/Python/notes.py
 ```

 Each link is a simple space-separated **key-value** pair, and uses the same
 indentation as the `TEXT` field starting at column 6 or higher.

<details>
<summary><b> Key </b></summary>
<br>

A key can consist of any combination of symbols, alphanumeric, and Unicode
characters except those that start with some predefined characters.

Available leading characters:
```
    ~!@$%^&*_()[]{}'`";,.\/? 0-9 a-z A-Z and Unicode characters
```
Used in the menu and syntax:
```
    -  previous     #  comment 
    =  main         |  command 
    +  new
    <  load
    >  unload
    :  command
```

The same key can be defined differently on each board.  

### Long keys

Long keys can be activated by typing only the unique prefix portion of the key.
For example, if you define a long key `xylophone` and no key starts with `xy`,
you can open the link with `xy` <kbd>Enter</kbd>.  

<br>
</details>

<details>
<summary><b> Path </b></summary>
<br>

To easily define a link to a file, the plugin supports copying the current file's path to a register
when the `menu` key is pressed (by default the `b` register).

To paste the path stored in register `b` in insert mode:

&nbsp; &nbsp; &nbsp; <kbd>Ctrl</kbd>+<kbd>R</kbd> `b`  
<br>

#### 🍏 &nbsp;Tip

When switching to another board stored in the `BoardPath` directory,
you can omit the path and specify only the file name.&nbsp; For example:
```vim
      'a  another.board
```
Switching boards using the defined keys will automatically load the links defined on the board.

<br>
</details>

<details>
<summary><b> Commands </b></summary>
<br>

Additional commands can be added using the `|` bar character.  

For example, to browse files after changing the current working directory:
```vim
      \py  ~/Languages/Python/ | edit .
```

After opening the file, to go to the line 128:
```vim
       pn  ~/Languages/Python/notes.py | 128
```

More commands can be combined together:
```vim
      \d1 ~/Directory/ | NERDTreeCWD | wincmd p | edit README.md
```

### Commands only 

You can also define just a list of commands without specifying a file or directory.

For example, to define a command that copies frequently used commands or strings to the clipboard:
```vim
      s1  | let @+ = "copy this string to the clipboard"
```

To define a substitution command:
```vim
      ss  | %s/Foo/Bar/gc
```

To define a set of temporary key-maps:
```vim
      key | nn f0 <Cmd>echo 0<CR>
          | nn f9 <Cmd>echo 9<CR>
```

To define some input from the shell tool to the scratchpad, `Board*`:
```vim
      sh1 | Board* | r! echo "This is the scratchpad on the Board"
      sh2 | Board* | r! curl -sI example.com
```

### Multi-line commands

Multi-line commands &nbsp;can be set using the leading bar `|` character.
```vim
      bar ~/directory/or_file
          | echo 'foo'
          | echo 'bar'
```

### Link reference

Links that have already been defined can be referenced using the '&' symbol. for example:
```vim
      _N  | NERDTreeCWD
      \d1 ~/Directory/ | &_N
```

### Command-line mode

When using the `|` bar character as a shell `pipe` or other meaning, you can
switch to command-line mode input by adding a colon `:` after the bar.

```vim
      sh3 | Board* |: r! ls | wc
      sh4 | Board* |: r! cat ~/.ssh/known_hosts | awk '$1 ~ /[0-9]/ { print $1; exit }'
```

### Stop command

To stop a long list of commands while processing, press the `menu` key and
input <kbd>Ctrl</kbd>+<kbd>C</kbd> or an undefined key.

</details>
<br>

## Help tags

For more information about commands and options, please refer to:
```vim
  :h Board
```

<br>

## Customizing Colors

The plugin provides two default color sets that can be automatically loaded depending on the current `background` mode.
You can use the native **hi** command to customize colors starting with `Board`, and save them to the configuration file
or color scheme.
```
 BoardHelp  BoardSection  BoardGroup  BoardSpecial  BoardMarker  BoardLink  BoardLed...
```

**Example**
```vim
  :hi BoardSpecial ctermfg=208 guifg=#ff8700
```
<br>

## Issues

If you have any issues that need fixing, comments or new features you would like to add, please feel free to open an issue.

<br>
