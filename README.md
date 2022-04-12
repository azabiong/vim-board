<!-- https://github.com/azabiong/vim-board -->

![vimModeStateDiagram](https://rawgit.com/darcyparker/1886716/raw/vimModeStateDiagram.svg)

> Special thanks to Darcy Parker for allowing reference to this wonderful artwork ▷ [origin](https://rawgit.com/darcyparker/1886716/raw/vimModeStateDiagram.svg)

<br>

# vim-board

This plugin introduces a file type `board` where you can easily erase and write summaries,
links to directories and files, and some additional commands.

#### Feature 1

> After assigning a '`key`' to the plugin, you can take quick notes on the board at any time while editing using:
>
> &nbsp; &nbsp; &nbsp; `Key` <kbd>Enter</kbd>
>
> and to return:
>
> &nbsp; &nbsp; &nbsp; `Key` <kbd>Esc</kbd>

#### Feature 2

> You can easily define shortcuts to directories or files on the board as simple **key-path** pairs. For example:
> ```
>   dt  ~/Documents/Terms/
>   v   ~/.vimrc
> ```
> Immediately after saving, you can use the following key sequences to change the
> current working directory, or open the file:
>
> &nbsp; &nbsp; &nbsp; `Key` `dt`
>
> &nbsp; &nbsp; &nbsp; `Key` `v`

<br>

## Installation

You can use your preferred plugin manager using the string `'azabiong/vim-board'`. For example:
```vim
 :Plug 'azabiong/vim-board'
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
The next step is to assign a convenient key to bring up the `board` with the `menu`. The plugin
default shortcut is a single quote and space if available.
```vim
    nmap '<Space> <Plug>(BoardMenu)
```
Now, save the changes and reload the configuration.

> At this point, you can try out the features in the introduction section above.

<br>

## Menu

Pressing the `BoardMenu` key will bring up the most recently used `board` with the `menu`.

<img height="26" alt="menu" src="https://user-images.githubusercontent.com/83812658/161204572-0c8f6aa7-8c0b-4fc4-b5da-82bbfb4e69e0.png"><br>

You can enter the key defined on the `board` to change the working directory or
open the file, or you can switch between boards using the following keys:

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

For manually opened boards, you can use the `(.)link` menu with the <kbd>.</kbd> key to
activate links defined on the board.
</details>
<br>

## Syntax

The `board` file syntax is relatively simple. You can use indentation and some
leading characters to mark each item differently.

### Section

The plugin uses sections to categorize content. Each section starts at the beginning of a line,
and can have different syntax depending on its type.

<div style="display:inline-block">
<img width="316" alt="default_light" src="https://user-images.githubusercontent.com/83812658/160866907-19b697fa-c9b3-4f50-8402-33c80fdc9c26.png">
<img width="316" alt="default_dark" src="https://user-images.githubusercontent.com/83812658/160867186-d91f778d-b182-408f-9598-1ff6981b7bc5.png">
</div><br>

### :Links Section

 The plugin loads links defined in this section. The following example defines
 two links:
 ```
        /p  ~/Languages/Python/
        pn  ~/Languages/Python/notes.py
 ```

 Each link is a simple space-separated **key-path** pair, and uses the same
 indentation as the `TEXT` field starting at column 6 or higher.

<details>
<summary><b> Commands </b></summary> 
<br>

You can also add additional commands using `|` bar. For example, to update
the `NERDTree` list after changing the current working directory: 
```vim
        /p  ~/Languages/Python/ | NERDTreeCWD
```

After opening the file, to scroll line 128 to the top:
```vim
        pn  ~/Languages/Python/notes.py | 128 | normal! zt
```
When switching to another board stored in the `BoardPath` directory, you can omit
the path and specify only the file name. For example:
```vim
        'r  reference.board
        /r  ~/Reference/Code/Library/ | reference.board | Hi:load reference
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
    ~!@$%^_()[]{}<>'"/?,0-9a-zA-Z and Unicode characters
```
Used in the syntax and menu:
```
    #  comment             ;  return
    :  setting             -  previous
    |  command             =  main
    *` special             +  new
    -  plain text          .  load
    &  reference           :  command
```
You can also define the same key differently on each board.

#### 🍏 &nbsp;Tip

When you suddenly have multiple to-do lists, numbering can be useful.
```vim
        t1  ~/Todo/file1 | /item | echo ' find item' 
        t2  ~/Todo/dir2/ | echo ' add file2'
```
#### Long key

You only need to enter the unique prefix part of the key. For example, if you
define a long key `xylophone` and don't have a key that starts with `xy`, you can
open the link with `xy` <kbd>Enter</kbd>.

<br>
</details>

<details>
<summary><b> Path </b></summary>
<br>

To easily define a link to a file, the plugin supports copying the current file's path to a register 
when the `menu` key is pressed (by default the `b` register) .  

To paste the path stored in register `b` in insert mode:

&nbsp; &nbsp; &nbsp; <kbd>Ctrl</kbd>+<kbd>R</kbd> `b`

<br>
</details>

<details>
<summary><b> Command list </b></summary>
<br>

**Multi-line commands** &nbsp;can be set using the leading bar `|` character.
```vim
        m   ~/directory/or_file
            | echo 'foo'
            | echo 'bar'
```
#### Stop command

To stop a long list of commands while processing, press the `menu` key and 
input <kbd>Ctrl</kbd>+<kbd>C</kbd> or an undefined key.  

#### Link reference

You can use the `&` symbol to run other links.
```vim
        N   | NERDTreeCWD
        d   ~/directory | &N
```

#### Commands only

You can also define just a list of commands.  

For example, to go back to the previous directory:
```vim
        <   | cd- | pwd
```

To copy a frequently used string to the clipboard:
```vim
        c1  | let @+ = "copy this string to the clipboard"
```

To define some input from the shell tool:
```vim
        c2  | Board* | r! echo "This is the scratchpad on the Board"
        c3  | Board* | r! curl -sI example.com
```

#### Command-line mode

When using the `|` bar character as a shell `pipe` or other meaning, you can
switch to command-line mode input by adding a `:` after the bar.

```vim
        c4  | Board* |: r! ls | wc
        c5  | Board* |: r! cat ~/.ssh/known_hosts | awk '$1 ~ /[0-9]/ { print $1; exit }'
```

</details>
<br>

## Help tags

For more information about commands and options, please refer to:
```vim
  :h Board
```

<br>

## Customizing Colors

The plugin provides two default color sets and automatically loads one depending on the current `background` mode.
You can use the Vim **hi** command to customize colors starting with `Board`,and save them to the configuration file
or color scheme.
```
 BoardSection  BoardGroup  BoardConfig  BoardMarker  BoardSpecial  BoardLed...  BoardHelp
```
<br>

## Issues

If you have any issues that need fixing, comments or new features you would like to add, please feel free to open an issue.

<br>
