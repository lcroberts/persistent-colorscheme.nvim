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
  opts.colorscheme = file:read '*l'
  if file:read '*l' == 'true' then
    opts.transparent = true
  else
    opts.transparent = false
  end
  file:close()

  return opts
end

M.make_transparent = function()
  vim.cmd 'hi Normal guibg=NONE'
  vim.cmd 'hi NormalNC guibg=NONE'
  vim.cmd 'hi FoldColumn guibg=NONE'
  vim.cmd 'hi SignColumn guibg=NONE'
  vim.cmd 'hi LineNr guibg=NONE'
end

M.load_state = function(opts)
  if vim.fn.filereadable(state_file) == 0 then
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
  file:write(opts.colorscheme .. '\n')
  file:write(tostring(opts.transparent) .. '\n')
  file:close()
end

return M
