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
