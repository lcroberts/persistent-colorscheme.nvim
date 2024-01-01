# persistent-colorscheme.nvim

This is a simple neovim plugin that will keep track of the last colorscheme you activated and load it on subsequent launches of neovim, as well as allow you to enable transparency for neovim.

## Installation

The plugin can be installed using the url `lcroberts/persistent-colorscheme.nvim` with your package manager of choice. As I use lazy, my provided example uses lazy. I recommend loading your colorscheme plugins before running the setup. In lazy this can be done by adding those plugins as a dependency for persistent-colorscheme. You should also load the plugin very early on in your config.

One thing to keep in mind is that some plugins that add multiple variants of the same theme may report the same colorscheme to neovim when the current colorscheme is queried. This can result in the correct variant not being saved. Check to see if you can configure the plugin to have a default version as folke allows in their tokyonight theme. Below is a snippet from my neovim config that demonstrates this.

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
      colorscheme = 'tokyonight',
    },
  }
```

## Configuration

Below is the default options:

```lua
{
  colorscheme = 'default', --- @type string - Default colorscheme if no cached data is found

  transparent = false,     --- @type boolean - Default transparency status if no cached data is found

  transparency_options = {
    groups = { ---@type string[]
      'FoldColumn',
      'Folded',
      'Normal',
      'NormalNC',
      'Comment',
      'Constant',
      'Special',
      'Identifier',
      'Statement',
      'PreProc',
      'Type',
      'Underlined',
      'Todo',
      'String',
      'Function',
      'Conditional',
      'Repeat',
      'Operator',
      'Structure',
      'LineNr',
      'NonText',
      'SignColumn',
      'CursorLine',
      'CursorLineNr',
      'StatusLine',
      'StatusLineNC',
      'EndOfBuffer',
    },

    additional_groups = {}, ---@type string[] - Additional highlight groups to be made transparent
    excluded_groups = {}, ---@type string[] - Groups exclude when enabling transparency
    transparent_prefixes = {}, ---@type string[] -- Highlight group prefixes to make transparent. All highlight groups starting with a prefix will be made transparent.
  },
}
```
