# persistent-colorscheme.nvim

> Note: This plugin is still a work in progress and may have bugs, though it is functional.

This is a simple neovim plugin that will keep track of the last colorscheme you activated and load it on subsequent launches of neovim.

Currently there is only one option, that being `default_colorscheme`. It allows you to choose the colorscheme that is loaded if one is not found. I recommend loading your desired colorschemes before the plugin. If you are using lazy.nvim like me you can use the snippet from [my neovim config](https://github.com/lcroberts/nvim-config) as a guide.

One thing to keep in mind is that some plugins that add multiple variants of the same theme may report the same colorscheme to neovim when the current colorscheme is queried. This can result in the correct variant not being saved. Check to see if you can configure the plugin to have a default version as folke allows in their tokyonight theme.

```lua
  {
    'lcroberts/persistent-colorscheme.nvim',
    lazy = false,
    priority = 1000,
    dependencies = {
      'RRethy/nvim-base16', -- Lots of baked-in themes and support to add more
      {
        'folke/tokyonight.nvim',
        opts = {
          style = 'night',
        },
      },
    },
    opts = {
      default_colorscheme = 'tokyonight',
    },
  }
```
