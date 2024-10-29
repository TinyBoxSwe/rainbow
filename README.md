# Rainbow Parentheses

A Neovim plugin that colors matching parentheses, brackets, and quotes with a rainbow effect.

## Installation

You can use [Lazy.nvim](https://github.com/folke/lazy.nvim) to install this plugin.

```lua
require('lazy').setup({
    'TinyBoxSwe/rainbow',
    config = function()
        require('rainbow').setup()
    end
})
```
## Usage
Once installed, the plugin will automatically highlight matching parentheses, brackets, and quotes in rainbow colors whenever you enter or modify a buffer.

Additionally you can set a custom rainbow withing the setup function:

```lua
require('rainbow').setup({
    colour_map = {
        { name = "Red",        fg = "#FF5252", bold = true },     -- Material Red
        { name = "Pink",       fg = "#FF4081", bold = true },     -- Material Pink
        { name = "Purple",     fg = "#7E57C2", bold = true },     -- Material Purple
        { name = "DeepPurple", fg = "#6200EA", bold = true },     -- Material Deep Purple
        { name = "Indigo",     fg = "#3F51B5", bold = true },     -- Material Indigo
        { name = "Blue",       fg = "#2196F3", bold = true },     -- Material Blue
        { name = "LightBlue",  fg = "#03A9F4", bold = true },     -- Material Light Blue
        { name = "Cyan",       fg = "#00BCD4", bold = true },     -- Material Cyan
        { name = "Teal",       fg = "#009688", bold = true },     -- Material Teal
        { name = "Green",      fg = "#4CAF50", bold = true },     -- Material Green
        { name = "LightGreen", fg = "#8BC34A", bold = true },     -- Material Light Green
        { name = "Lime",       fg = "#CDDC39", bold = true },     -- Material Lime
        { name = "Yellow",     fg = "#FFEB3B", bold = true },     -- Material Yellow
        { name = "Amber",      fg = "#FFC107", bold = true },     -- Material Amber
        { name = "Orange",     fg = "#FF9800", bold = true },     -- Material Orange
        { name = "DeepOrange", fg = "#FF5722", bold = true },     -- Material Deep Orange
    }
})
```
