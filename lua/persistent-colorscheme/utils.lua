local vim = vim
local state_file = vim.fn.stdpath 'data'
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  state_file = state_file .. '\\persistent-colorscheme'
else
  state_file = state_file .. '/persistent-colorscheme'
end
local M = {}

M.parse_file = function()
  local opts = {}
  local file = io.open(state_file, 'r')
  if file == nil then
    print 'Error opening state_file'
    return
  end
  opts = vim.json.decode(file:read '*a')
  file:close()
  return opts
end

M.make_transparent = function()
  for _, x in ipairs(vim.g.transparency_groups) do
    vim.api.nvim_set_hl(0, x, { force = true, bg = 'NONE', ctermbg = 'NONE' })
  end
end

M.enable_transparency = function()
  M.make_transparent()
  local opts = M.parse_file()
  opts.transparent = true
  M.write_state(opts)
end

M.disable_transparency = function()
  local opts = M.parse_file()
  vim.cmd.colorscheme(opts.colorscheme)
  opts.transparent = false
  M.write_state(opts)
end

M.toggle_transparency = function()
  local opts = M.parse_file()
  if opts.transparent then
    M.disable_transparency()
  else
    M.enable_transparency()
  end
end

M.load_state = function(opts)
  if vim.fn.filereadable(state_file) == 0 then
    M.write_state(opts)
    return
  end
  opts = M.parse_file()
  vim.cmd.colorscheme(opts.colorscheme)
  if opts.transparent then
    M.make_transparent()
  end
end

M.write_state = function(opts)
  local file = io.open(state_file, 'w')
  if file == nil then
    print 'Error opening state file'
    return
  end
  file:write(vim.json.encode(opts))
  file:close()
end

return M
