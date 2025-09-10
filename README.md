My Dotfiles (work in progress)

## Neovim Keybindings

**Leader key:** `<space>`

### General
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<leader>wq` | Normal | Save and quit |
| `Q` | Normal | Disabled (no-op) |
| `<leader>/` | Normal | Clear search highlight |

### Window Navigation
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to down window |
| `<C-k>` | Normal | Move to up window |
| `<C-l>` | Normal | Move to right window |

### Window Management
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<A-h>` | Normal | Move window left |
| `<A-j>` | Normal | Move window down |
| `<A-k>` | Normal | Move window up |
| `<A-l>` | Normal | Move window right |
| `<C-w>c` | Normal | Smart close window/buffer |
| `<leader>c` | Normal | Smart close window/buffer |
| `<leader>qa` | Normal | Close all files |

### Buffer Management
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<leader>bn` | Normal | Next buffer |
| `<leader>bp` | Normal | Previous buffer |
| `<leader>bd` | Normal | Close buffer |
| `<leader>b` | Normal | Pick buffer |
| `<leader>p` | Normal | Pick buffer |
| `<A-,>` | Normal | Previous buffer |
| `<A-.>` | Normal | Next buffer |
| `<A-<>` | Normal | Move buffer left |
| `<A->>` | Normal | Move buffer right |
| `<A-1>` to `<A-9>` | Normal | Go to buffer 1-9 |
| `<A-0>` | Normal | Go to last buffer |
| `<A-p>` | Normal | Pin buffer |
| `<A-c>` | Normal | Close buffer |

### Tab Management
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<C-t>` | Normal | New tab |
| `<C-w>` | Normal | Close tab |
| `<A-Right>` | Normal | Next tab |
| `<A-Left>` | Normal | Previous tab |

### File Explorer & Search
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<C-b>` | Normal | Toggle NvimTree |
| `<C-p>` | Normal | Find files (Telescope) |
| `<leader>ff` | Normal | Find files (Telescope) |
| `<leader>fb` | Normal | Find buffers (Telescope) |
| `<leader>fg` | Normal | Live grep (Telescope) |
| `<leader>fh` | Normal | Help tags (Telescope) |

### Terminal
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<Esc>` | Terminal | Exit terminal mode |
| `<C-n>` | Normal | Toggle terminal |

### Line Navigation
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<Home>` | Normal/Visual | Go to first non-blank character |
| `<End>` | Normal/Visual | Go to end of line |
| `<Home>` | Insert | Go to first non-blank character |
| `<End>` | Insert | Go to end of line |
| `<Home>` | Command | Go to beginning of command line |
| `<End>` | Command | Go to end of command line |

### Git (Gitsigns)
| Keybinding | Mode | Description |
|------------|------|-------------|
| `]c` | Normal | Next hunk |
| `[c` | Normal | Previous hunk |
| `<leader>hs` | Normal/Visual | Stage hunk |
| `<leader>hr` | Normal/Visual | Reset hunk |
| `<leader>hS` | Normal | Stage buffer |
| `<leader>hu` | Normal | Undo stage hunk |
| `<leader>hR` | Normal | Reset buffer |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame line |
| `<leader>tb` | Normal | Toggle blame |
| `<leader>hd` | Normal | Diff this |
| `<leader>hD` | Normal | Diff this ~ |
| `<leader>td` | Normal | Toggle deleted |
| `ih` | Operator/Visual | Select hunk |
| `<leader>gg` | Normal | LazyGit |

### LSP
| Keybinding | Mode | Description |
|------------|------|-------------|
| `gD` | Normal | Go to declaration |
| `gd` | Normal | Go to definition |
| `K` | Normal | Hover |
| `gi` | Normal | Go to implementation |
| `<C-k>` | Normal | Signature help |
| `<leader>wa` | Normal | Add workspace folder |
| `<leader>wr` | Normal | Remove workspace folder |
| `<leader>wl` | Normal | List workspace folders |
| `<leader>D` | Normal | Type definition |
| `<leader>rn` | Normal | Rename |
| `<leader>ca` | Normal | Code action |
| `gr` | Normal | References |
| `<leader>f` | Normal | Format |

### Claude Code Integration
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<leader>cc` | Normal | Claude Code Interact |
| `<leader>ca` | Normal | Claude Code Analyze |
| `<leader>cf` | Normal | Claude Code Fix |
| `<leader>gc` | Normal | Claude Code Commit |
| `<leader>ce` | Visual | Claude Code Explain |

### Configuration
| Keybinding | Mode | Description |
|------------|------|-------------|
| `<leader>ev` | Normal | Edit vimrc |
| `<leader>sv` | Normal | Source vimrc |


## Tmux Keybindings
**Prefix key:** `C-a`
**Repeatable:** Commands marked as repeatable can be executed multiple times after pressing prefix once

### Prefix Key
| Keybinding | Description |
|------------|-------------|
| `C-a` | Prefix key (instead of default C-b) |
| `C-a C-a` | Send prefix to nested session |

### Session Management
| Keybinding | Description |
|------------|-------------|
| `C-a r` | Reload tmux configuration |

### Window Management
| Keybinding | Description |
|------------|-------------|
| `C-a c` | Create new window (in current path) |
| `C-a p` | Previous window |
| `C-a C-h` | Previous window (repeatable) |
| `C-a C-l` | Next window (repeatable) |

### Pane Management
| Keybinding | Description |
|------------|-------------
| `C-a \` | Split window horizontally (in current path) |
| `C-a -` | Split window vertically (in current path) |
| `C-a ^A` | Cycle through panes |

### Pane Navigation
| Keybinding | Description |
|------------|-------------|
| `M-Left` | Select left pane |
| `M-Right` | Select right pane |
| `M-Up` | Select upper pane |
| `M-Down` | Select lower pane |
| `M-1` to `M-9` | Select pane by number |

### Pane Resizing
| Keybinding | Description |
|------------|-------------|
| `C-a h` | Resize pane right (repeatable) |
| `C-a j` | Resize pane down (repeatable) |
| `C-a k` | Resize pane up (repeatable) |
| `C-a l` | Resize pane left (repeatable) |

