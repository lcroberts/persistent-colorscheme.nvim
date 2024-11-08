# persistent-colorscheme.nvim

This is a simple neovim plugin that will keep track of the last colorscheme you activated and load it on subsequent launches of neovim, as well as allow you to enable transparency for neovim.

## Installation

One thing to keep in mind is that some plugins that add multiple variants of the same theme may report the same colorscheme to neovim when the current colorscheme is queried. This can result in the correct variant not being saved. Check to see if you can configure the plugin to have a default version as folke allows in their tokyonight theme. Below is a snippet from my neovim config that demonstrates this.

```lua
  {
    'lcroberts/persistent-colorscheme.nvim',
    lazy = false,
    priority = 1000, -- Plugin should be loaded early
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
    always_transparent = {}, ---@type string[] -- Highlight groups that will always be transparent regardless of transparency status
  },
}
```

## Plugins

Many plugins have their own highlight groups. Simply adding them to the `additional_groups` or `transparent_prefixes` options may not behave correctly so you will want to handle those transparency groups after the plugin has loaded. There are several ways to do this.

### Extend g:transparent_groups

The first way to handle plugin transparency groups is to add them to the global variable `transparent_groups`. There is a watcher for the variable that will detect newly added highlight groups and make them transparent. Here is an example that handles the bufferline transparency groups.

```lua
vim.g.transparent_groups = vim.list_extend(
  vim.g.transparent_groups or {},
  vim.tbl_map(function(v)
    return v.hl_group
  end, vim.tbl_values(require('bufferline.config').highlights))
)
```

### Use `make_prefix_transparent`

Another way to handle plugin highlight groups is the use the `make_prefix_transparent` function. This is useful when the highlight groups share a common prefix. Below is an example I use for the gitsigns plugin to death with the signs in the sign column.

```lua
require('persistent-colorscheme').make_prefix_transparent 'GitGutter'
```

## Why does this plugin exist?

This plugin is useful if you use the same neovim config across multiple devices and want to use different colorchemes or have different appearance options on each device. It is also useful if you are someone who just enjoys changing colorschemes often as well.

## Credits

Thanks to xiyaowong and their work on [transparent.nvim](https://github.com/xiyaowong/transparent.nvim). It was very useful as a reference on how to handle highlight groups and prevent any weirdness. If all you care about is the transparency, then this is a better option.
