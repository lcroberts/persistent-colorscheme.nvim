local M = {}

local config = {
  --- @type string
  colorscheme = 'default',

  --- @type boolean
  transparent = false,

  transparency_options = {
    groups = {
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

    additional_groups = {},
    excluded_groups = {},
    transparent_prefixes = {},
  },
}

M.setup = function(opts)
  opts = opts or {}

  config = vim.tbl_deep_extend('keep', opts, config)
end

return setmetatable(M, {
  __index = function(_, k)
    return config[k]
  end,
})
