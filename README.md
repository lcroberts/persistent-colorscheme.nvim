# persistent-colorscheme.nvim

> Note: This plugin is still a work in progress and may have bugs, though it should be functional.

This is a simple neovim plugin that will keep track of the last colorscheme you activated and load it on subsequent launches of neovim.

Below is a list of options:

| Option Name         | Description                              | Type    |
| ------------------- | ---------------------------------------- | ------- |
| default_colorscheme | The colorscheme used if one is not found | string  |
| transparent         | If enabled makes neovim transparent      | boolean |

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

Below is the default options:

```lua
{
  --- @type string
  default_colorscheme = 'default',

  --- @type boolean
  transparent = false,
}
```
