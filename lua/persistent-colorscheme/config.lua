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

local function make_prefixes_transparent()
  local pcs = require 'persistent-colorscheme'

  for _, prefix in ipairs(config.transparency_options.transparent_prefixes) do
    pcs.make_group_transparent(vim.fn.getcompletion(prefix, 'highlight'))
  end
end

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
