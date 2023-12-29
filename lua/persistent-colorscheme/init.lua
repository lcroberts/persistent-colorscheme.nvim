local vim = vim
local utils = require 'persistent-colorscheme.utils'
local M = {}

local state_file = vim.fn.stdpath 'data'
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  state_file = state_file .. '\\persistent-colorscheme'
else
  state_file = state_file .. '/persistent-colorscheme'
end

local defaults = {
  --- @type string
  colorscheme = 'default',

  --- @type boolean
  transparent = false,

  transparent_groups = {
    'Normal',
    'NormalNC',
    'Type',
    'LineNr',
    'SignColumn',
    'CursorLine',
    'CursorLineNr',
    'StatusLine',
    'StatusLineNC',
    'EndOfBuffer',
    'FoldColumn',
  },
}

M.setup = function(options)
  local opts = vim.tbl_deep_extend('keep', options or {}, defaults)
  vim.g.transparency_groups = opts.transparent_groups
  opts.transparent_groups = nil
  vim.cmd.colorscheme(opts.colorscheme)
  if opts.transparent then
    utils.make_transparent()
  end

  utils.load_state(opts)

  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    group = vim.api.nvim_create_augroup('ColorSchemePersist', { clear = true }),
    callback = function()
      opts = utils.parse_file()
      if opts.transparent then
        utils.make_transparent()
      end
      opts.colorscheme = vim.g.colors_name
      utils.write_state(opts)
    end,
  })
end

return M
