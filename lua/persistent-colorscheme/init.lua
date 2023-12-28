local vim = vim
local utils = require 'persistent-colorscheme.utils'
local M = {}

local color_file = vim.fn.stdpath 'data'
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  color_file = color_file .. '\\persistent-colorscheme'
else
  color_file = color_file .. '/persistent-colorscheme'
end

local defaults = {
  --- @type string
  colorscheme = 'default',

  --- @type boolean
  transparent = false,
}

M.setup = function(options)
  local opts = vim.tbl_deep_extend('keep', options or {}, defaults)
  vim.cmd.colorscheme(opts.colorscheme)
  if opts.transparent then
    utils.make_transparent()
  end

  utils.load_state()
  if opts.transparent then
    utils.make_transparent()
  end

  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    group = vim.api.nvim_create_augroup('ColorSchemePersist', { clear = true }),
    callback = function()
      opts.colorscheme = vim.g.colors_name
      utils.write_state(opts)
      if opts.transparent then
        utils.make_transparent()
      end
    end,
  })
end

return M
