local M = {}

local config = {
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
    always_transparent = {}, ---@type string[] -- Hihglight groups that will always be transparent regardless of transparency status
  },
}

local function make_prefixes_transparent()
  local pcs = require 'persistent-colorscheme'

  for _, prefix in ipairs(config.transparency_options.transparent_prefixes) do
    pcs.make_group_transparent(vim.fn.getcompletion(prefix, 'highlight'))
  end
end

---@param opts table
M.setup = function(opts)
  opts = opts or {}

  config = vim.tbl_deep_extend('keep', opts, config)
  make_prefixes_transparent()
end

return setmetatable(M, {
  __index = function(_, k)
    return config[k]
  end,
})
