<!-- https://github.com/azabiong/vim-board -->

# vim-board

<p><h6> &nbsp;&nbsp; ver 1.16 </h6></p>

This plugin introduces a file type `board` where you can easily write notes,
and define shortcuts to directories, files, and various commands.

#### Feature 1

> After assigning a `Key` to the plugin, you can take quick notes on the board at any time while editing using:
>
> &nbsp; &nbsp; &nbsp; `Key` <kbd>Enter</kbd>
>
> and to return:
>
> &nbsp; &nbsp; &nbsp; `Key` <kbd>Esc</kbd>

#### Feature 2

> You can easily define shortcuts to directories, files, and commands on the board using simple **key-value** pairs.
> For example:
> ```
>   /t  ~/Documents/Terms/
>   v   ~/.vimrc
> ```
> Immediately after saving, you can use the following key sequences to change the
> current working directory, or open the file:
>
> &nbsp; &nbsp; &nbsp; `Key` `/t`
>
> &nbsp; &nbsp; &nbsp; `Key` `v`

<br>

## Installation

You can use your preferred plugin manager using the string `'azabiong/vim-board'`. For example:
```vim
 Plug 'azabiong/vim-board'
```
<details>
<summary> &nbsp; or,&nbsp; Vim 8 pack feature: </summary>
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
<summary><b>&nbsp; nvim &nbsp;.lua </b></summary>

```lua
  vim.g.BoardPath = '~/.vim/after/vim-board'

  vim.api.nvim_set_keymap('n', "'<Space>", '<Plug>(BoardMenu)', {})
```
</details>

Now, save the changes and reload the plugin.

> At this point, you can try out the features in the introduction section above.

<br>

## Menu

Pressing the `BoardMenu` key will bring up the auto-expanding menu with the most recently used `board`.

<img height="26" alt="menu" src="https://user-images.githubusercontent.com/83812658/164972992-a76fd0b7-a5c8-4403-ab40-690ced07d21d.gif"> <br>

You can enter the key you have defined on the `board`, or switch between boards using the following keys:

<details>
<summary><b> keys </b></summary>
<br>

  |key|function|
  |:--:|:--|
  |<kbd>Enter</kbd>|edit current board|
  |<kbd>Esc</kbd>  |return|
  |<kbd>;</kbd>    |return|
  |<kbd>Space</kbd>|scroll down|
  |<kbd>↓</kbd>    |scroll down|
  |<kbd>↑</kbd>    |scroll up|
  |<kbd>Ctrl</kbd><kbd>Space</kbd> |scroll up|
  |<kbd>-</kbd>    |switch to previous board|
  |<kbd>=</kbd>    |switch to main board|
  |<kbd>+</kbd>    |add new board|
  |<kbd>.</kbd>    |link current board|
  |<kbd>:</kbd>    |command-line mode|

> For manually opened boards, you can use the <kbd>.</kbd> key to activate links defined on the board.
</details>
<br>

## Syntax

The `board` file syntax is simple. You can use indentation and some leading characters
to mark each item differently.

### Section

The plugin uses sections to categorize content. Each section starts at the beginning of a line,
and can have different syntax depending on its type.

<div style="display:inline-block">
<img width="315" alt="board_light" src="https://user-images.githubusercontent.com/83812658/209437944-cdfc79bc-819b-4b38-9cf6-71edb80c0eff.png">
<img width="315" alt="board_dark" src="https://user-images.githubusercontent.com/83812658/209437963-67ea4c14-1da6-40b0-939e-dfa4e6981ad6.png">
</div><br>

### :Links Section

 The plugin loads the shortcut links defined in this section. The following example defines
 two links:
 ```
        /p  ~/Languages/Python/
        pn  ~/Languages/Python/notes.py
 ```

 Each link is a simple space-separated **key-value** pair, and uses the same
 indentation as the `TEXT` field starting at column 6 or higher.

<details>
<summary><b> Commands </b></summary>
<br>

You can also add additional commands using `|` bar.  

For example, to browse files after changing the current working directory:
```vim
        /p  ~/Languages/Python/ | edit .
```

After opening the file, to go to the line 128:
```vim
        pn  ~/Languages/Python/notes.py | 128
```

More commands can be combined together:
```vim
        /d1 ~/Directory/ | NERDTreeCWD | wincmd p | edit README.md
```

<br>
</details>

<details>
<summary><b> Key </b></summary>
<br>

A key can consist of any combination of symbols, alphanumeric, and Unicode
characters except those that start with some predefined characters.

Available leading characters:
```
    ~`!@$%^&*_()[]{}<>'",/? 0-9 a-z A-Z and Unicode characters
```
Used in the menu and syntax:
```
    ;  return       #  comment
    -  previous     |  command
    =  main
    +  new
    .  load
    :  command
```
You can also define the same key differently on each board.

#### 🍏 &nbsp;Tip

When you suddenly have multiple to-do lists, numbering can be useful.
```vim
        t1  ~/Todo/file1 | /item | echo 'find item'
        t2  ~/Todo/dir2/ | echo 'add file2'
```
Or, to stack items in something like queue `0`
```vim
        0   ~/dir/third
        0   ~/dir/second
        0   ~/dir/first
```
You can use the `0` key to open the bottom item, and then clear or move it when you're done.  
When opening the item in the middle, the native `gf` command would be useful.

#### Long key

You only need to enter the unique prefix part of the key. For example,
if you define a long key `xylophone` and no key starts with `xy`, 
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

When switching to another board stored in the `BoardPath` directory, you can omit the path and specify only the file name.
Switching boards using the keys will automatically load the links defined on the board.
```vim
        'a  another.board
```

<br>
</details>

<details>
<summary><b> Command list </b></summary>
<br>

**Multi-line commands** &nbsp;can be set using the leading bar `|` character.
```vim
        bar ~/directory/or_file
            | echo 'foo'
            | echo 'bar'
```

#### Commands only

You can also define just a list of commands.

For example, to copy a frequently used string or command to the clipboard:
```vim
        c1  | let @+ = "copy this string to the clipboard"
```

To define a substitution command:
```vi
        sub | %s/Foo/Bar/gc
```

To define a set of temporary key-maps:
```vi
        key | nn f0 <Cmd>echo 0<CR>
            | nn f9 <Cmd>echo 9<CR>
```

To define some input from the shell tool to the scratchpad, `Board*`:
```vim
        s1  | Board* | r! echo "This is the scratchpad on the Board"
        s2  | Board* | r! curl -sI example.com
```

#### Command-line mode

When using the `|` bar character as a shell `pipe` or other meaning, you can
switch to command-line mode input by adding a colon `:` after the bar.

```vim
        s3  | Board* |: r! ls | wc
        s4  | Board* |: r! cat ~/.ssh/known_hosts | awk '$1 ~ /[0-9]/ { print $1; exit }'
```

#### Link reference

You can use the `&` symbol to run other links. For example:
```vim
        _N  | NERDTreeCWD
        /d1 ~/Directory/ | &_N
```

#### Stop command

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
