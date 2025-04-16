require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = 'both' -- to enable cursorline!

o.history = 100           -- Vim History to 100 lines
o.ruler = true            -- Display cursor position in the bottom part of the file
o.showmode = true         -- Show current mode

-- Appearance and Behavior
o.showmatch = true        -- Highlights matching parentheses or braces (useful for programming)
o.scrolloff = 4           -- Keeps 4 lines visible when scrolling so the cursor doesn't go to the edge
o.list = false            -- Hides special characters like tabs and trailing spaces by default

-- Encoding and Performance
o.encoding = 'utf-8'      -- Terminal encoding to UTF-8
o.lazyredraw = true       -- Will not update the display when executing a macro

-- Command Line and Undo Settings
o.cmdheight = 1           -- Set command line height to one row
o.undolevels = 1000       -- Sets max number of undo levels
o.undofile = true         -- Persistent Undo
o.showcmd = true          -- Partial commands in the command bar

-- File Management
o.backupdir = '~/.vim/backup//'   -- Backup file directory
o.directory = '~/.vim/swap//'     -- Swap file directory
o.undodir = '~/.vim/undo//'       -- Undo file directory

-- Indentation and Tab Settings
o.tabstop = 4             -- Sets the length of the tab from default=8 to 4
o.shiftwidth = 4          -- Length of auto-indent
o.expandtab = false       -- Tab is tab instead of spaces
o.softtabstop = 4         -- When backspacing, tabs are treated as 4 in length
o.backspace = 'indent,eol,start'  -- Backspacing also over indents, line breaks and insert starts
o.shiftround = true       -- Each tab is multiples of shiftwidth
o.copyindent = true       -- Copies the previous line's indentation when autoindent

-- Security and Convenience
o.modeline = false        -- Disables the modelines for security reasons
o.wildmenu = true         -- Make tab completion show choices in a menu
o.wildmode = 'list:full'  -- Lists matches first then complete the first full match
o.wildignore = '*.swp,*.bak,*.pyc,*.class'  -- Ignores these file types during completion

-- Clipboard and Search
o.clipboard = 'unnamedplus,unnamed'  -- Add clipboard support
o.hlsearch = true         -- Highlighted Search Results
o.incsearch = true        -- Incremental search (shows matches as you type)

-- Filetype and Syntax
vim.cmd('syntax on')      -- Syntax Highlighting
vim.cmd('filetype plugin on')    -- Filetype Plugin
vim.cmd('filetype indent on')    -- Indentation for file types
o.autoindent = true       -- Enable automatic indenting
o.smartindent = true      -- Enables smart indenting

-- Line Number Settings
o.number = true           -- Show absolute line numbers
o.relativenumber = true   -- Show relative line numbers

-- Status Line
o.laststatus = 2          -- Better Status Line
