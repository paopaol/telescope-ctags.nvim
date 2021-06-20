# telescope-ctags.nvim

An extension for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) that allows you to list current file of functions


> currently only support cpp


## Setup

```lua
paq 'nvim-telescope/telescope.nvim'
paq 'paopaol/telescope-ctags.nvim'
```

You can setup the extension by adding the following to your config:
```lua
require'telescope'.load_extension('ctags')
```

## Usage

```viml
:Telescope ctags functions
```
