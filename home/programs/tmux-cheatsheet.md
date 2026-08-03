# TMUX // MNEMOSYNE FIELD MANUAL

Every shortcut starts with `Ctrl-a`, then release both keys and press the key
shown below. Press `Ctrl-a Ctrl-a` to send a literal `Ctrl-a` to an application.

## Survival

| Key | Action |
| --- | --- |
| `d` | Detach; everything keeps running |
| `?` | Open this cheatsheet |
| `r` | Reload the tmux configuration |
| `C-s` | Save a session snapshot now |
| `C-r` | Restore the last session snapshot |
| `Y` | Toggle synchronized typing across panes |
| `C-l` | Clear the active pane and its scrollback |

Sessions are also saved automatically every 10 minutes. Interactive terminals
attach to the persistent `dev` session automatically.

## Panes

| Key | Action |
| --- | --- |
| `|` | Split right in the current directory |
| `-` | Split below in the current directory |
| `h j k l` | Focus pane left / down / up / right |
| `H J K L` | Resize pane left / down / up / right |
| `z` | Zoom or unzoom the active pane |
| `q` | Flash pane numbers; press a number to jump |
| `x` | Kill the active pane, with confirmation |
| `!` | Break the active pane into its own window |

Mouse selection, pane resizing, and window selection are enabled too.

## Windows and sessions

| Key | Action |
| --- | --- |
| `c` | Create a window in the current directory |
| `n` / `p` | Next / previous window |
| `1` … `9` | Jump directly to a numbered window |
| `,` | Rename the current window |
| `&` | Kill the current window, with confirmation |
| `<` / `>` | Move the window left / right |
| `s` | Interactive session, window, and pane tree |
| `w` | Interactive window tree |

## Wicked machinery

| Key | Action |
| --- | --- |
| `g` | Lazygit in a floating popup |
| `e` | Helix in a floating popup |
| `b` | Btop in a floating popup |
| `F` | Fuzzy-find sessions, windows, panes, commands, or keys |
| `Space` | Highlight URLs, hashes, paths, and numbers for copying |

In thumbs mode, type a lowercase hint to copy it or an uppercase hint to paste
it. OSC52 forwards copies through SSH to the local terminal clipboard.

## Copy mode

| Key | Action |
| --- | --- |
| `[` | Enter scroll/copy mode |
| `v` | Begin a Vim-style selection |
| `C-v` | Toggle rectangular selection |
| `y` | Copy selection and leave copy mode |
| `q` | Leave copy mode without copying |

Use Vim movement keys or the mouse while selecting. Page Up also enters copy
mode and scrolls through the 200,000-line history.
