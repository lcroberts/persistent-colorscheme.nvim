local vim = vim
local utils = require 'persistent-colorscheme.utils'
local config = require 'persistent-colorscheme.config'
local group_prefix_list = config.transparency_options.transparent_prefixes
local M = {}

utils.load_state()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('UpdateColorschemeCache', { clear = true }),
  callback = function()
    utils.write_state()
  end,
})

-- Makes a group of highlight groups transparent
---@param group string|string[]
local function make_group_transparent(group)
  local groups = type(group) == 'string' and { group } or group
  for _, v in ipairs(group) do
    if not vim.tbl_contains(config.transparency_options.excluded_groups, v) then
      local ok, prev_attrs = pcall(vim.api.nvim_get_hl, 0, { name = v })
      if ok and (prev_attrs.background or prev_attrs.bg or prev_attrs.ctermbg) then
        local attrs = vim.tbl_extend('force', prev_attrs, { bg = 'NONE', ctermbg = 'NONE' })
        attrs[true] = nil
        vim.api.nvim_set_hl(0, v, attrs)
      end
    end
  end
end

-- Enables trasparency for all transparency sources
local function make_transparent()
  if vim.g.transparent_enabled ~= true then
    return
  end

  make_group_transparent(config.transparency_options.groups)
  make_group_transparent(config.transparency_options.additional_groups)
  make_group_transparent(type(vim.g.transparent_groups) == 'table' and vim.g.transparent_groups or {})
  for _, prefix in ipairs(group_prefix_list) do
    make_group_transparent(vim.fn.getcompletion(prefix, 'highlight'))
  end
end

-- Enables trasparency for all transparency sources
function M.make_transparent()
  if vim.g.transparent_enabled ~= true then
    return
  end
  make_transparent()
end

-- Toggles transparency when called with no arguments.
-- When called with an argument it will set the transparency accordingly.
---@param opt boolean
function M.toggle(opt)
  if opt == nil then
    vim.g.transparent_enabled = not vim.g.transparent_enabled
  else
    vim.g.transparent_enabled = opt
  end
  utils.write_state()
  if vim.g.colors_name then
    pcall(vim.cmd.colorscheme, vim.g.colors_name)
  else
    make_transparent()
  end
end

-- Makes all highlight groups with the provided prefix transparent.
---@param prefix string
function M.make_prefix_transparent(prefix)
  if not prefix or prefix == '' then
    return
  end
  if not vim.tbl_contains(group_prefix_list, prefix) then
    table.insert(group_prefix_list, prefix)
  end
  make_group_transparent(vim.fn.getcompletion(prefix, 'highlight'))
end

-- Makes newly added groups transparent
function M.handle_groups_changed(arg)
  local old = arg.old or {}
  local new = arg.new or {}
  if type(old) == 'table' and type(new) == 'table' and vim.tbl_islist(old) and vim.tbl_islist(new) then
    make_group_transparent(vim.tbl_filter(function(v)
      return not vim.tbl_contains(old, v)
    end, new))
  else
    vim.notify 'g:transparent_groups must be a list'
  end
end

M.setup = config.setup
M.make_group_transparent = make_group_transparent

return M
