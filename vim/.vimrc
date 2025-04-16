" Vim settings instead of Vi
set nocompatible

" General Settings
set history=100           " Vim History to 100 lines
set ruler                 " Display cursor position in the bottom part of the file
set showmode              " Show current mode

" Appearance and Behavior
set showmatch             " Highlights matching parentheses or braces (useful for programming)
set scrolloff=4           " Keeps 4 lines visible when scrolling so the cursor doesn't go to the edge
set nolist                " Hides special characters like tabs and trailing spaces by default

" Encoding and Performance
set termencoding=utf-8    " Terminal encoding to UTF-8
set encoding=utf-8        " Vim's internal character encoding to UTF-8
set lazyredraw            " Will not update the display when executing a macro

" Command Line and Undo Settings
set cmdheight=1           " Set command line height to one row
set undolevels=1000       " Sets max number of undo levels
set undofile              " Persistent Undo
set showcmd               " Partial commands in the command bar

" File Management
set backupdir=/home/joeyboi/.vim/backup//   " Backup file directory
set directory=/home/joeyboi/.vim/swap//     " Swap file directory
set undodir=/home/joeyboi/.vim/undo//       " Undo file directory

" Indentation and Tab Settings
set tabstop=4              " Sets the length of the tab from default=8 to 4
set shiftwidth=4           " Length of auto-indent
set noexpandtab            " Tab is tab instead of spaces
set softtabstop=4          " When backspacing, tabs are treated as 4 in length
set backspace=indent,eol,start  " Backspacing also over indents, line breaks and insert starts
set shiftround            " Each tab is multiples of shiftwidth
set copyindent            " Copies the previous line's indentation when autoindent

" Security and Convenience
set nomodeline            " Disables the modelines for security reasons
set wildmenu              " Make tab completion show choices in a menu
set wildmode=list:full    " Lists matches first then complete the first full match
set wildignore=*.swp,*.bak,*.pyc,*.class  " Ignores these file types during completion

" Clipboard and Search
set clipboard=unnamedplus,unnamed  " Add clipboard support
set hlsearch              " Highlighted Search Results
set incsearch             " Incremental search (shows matches as you type)

" Filetype and Syntax
syntax on                 " Syntax Highlighting
filetype plugin on        " Filetype Plugin
filetype indent on        " Indentation for file types
set autoindent            " Enable automatic indenting
set smartindent           " Enables smart indenting

" Line Number Settings
set number                " Show absolute line numbers
set relativenumber        " Show relative line numbers

" Status Line
set laststatus=2          " Better Status Line

" Plugins and Color Scheme
"colorscheme zaibatsu      " Gvim ColorScheme

" Vim-Plug Plugin Manager Setup
"call plug#begin('~/.vim/plugged')

" Install fuzzy finder and integration with fzf
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

" End plugin manager setup
"call plug#end()
