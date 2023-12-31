local vim = vim
local utils = require 'persistent-colorscheme.utils'
local M = {}

local state_file = vim.fn.stdpath 'data'
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  state_file = state_file .. '\\persistent-colorscheme'
else
  state_file = state_file .. '/persistent-colorscheme'
end

local defaults = require 'persistent-colorscheme.config'

M.setup = function(options)
  local opts = vim.tbl_deep_extend('keep', options or {}, defaults)
  vim.g.transparent_groups = opts.transparency_options.transparent_groups
  vim.g.transparent_groups_excluded = opts.transparency_options.transparent_groups_excluded
  vim.g.transparent = opts.transparent
  M.add_transparency_groups(opts.transparency_options.additional_groups)
  opts.transparency_options = nil
  vim.cmd.colorscheme(opts.colorscheme)
  if vim.g.transparent then
    utils.make_transparent()
  end

  utils.load_state(opts)

  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    group = vim.api.nvim_create_augroup('ColorSchemePersist', { clear = true }),
    callback = function()
      opts = utils.parse_file()
      if vim.g.transparent then
        utils.make_transparent()
      end
      opts.colorscheme = vim.g.colors_name
      utils.write_state()
    end,
  })
end

M.enable_transparency = function()
  if vim.g.transparent then
    return
  end
  utils.make_transparent()
  utils.write_state()
end

M.disable_transparency = function()
  if not vim.g.transparent then
    return
  end
  vim.g.transparent = false
  utils.write_state()
  vim.cmd.colorscheme(vim.g.colors_name)
end

M.toggle_transparency = function()
  if vim.g.transparent then
    M.disable_transparency()
    M.disable_transparency()
  else
    M.enable_transparency()
  end
end

M.add_transparency_groups = function(groups)
  vim.g.transparent_groups = vim.list_extend(groups, vim.g.transparent_groups or {})
  if vim.g.transparent then
    utils.make_transparent()
  end
end

M.add_excluded_groups = function(groups)
  vim.g.transparent_groups_excluded = vim.list_extend(groups, vim.g.transparent_groups_excluded or {})
  if vim.g.transparent then
    utils.make_transparent()
  end
end

vim.api.nvim_create_user_command('TransparencyEnable', function()
  M.enable_transparency()
end, {})
vim.api.nvim_create_user_command('TransparencyToggle', function()
  M.toggle_transparency()
end, {})
vim.api.nvim_create_user_command('TransparencyDisable', function()
  M.disable_transparency()
  M.disable_transparency()
end, {})

return M
