local vim = vim
local color_file = vim.fn.stdpath 'data'
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  color_file = color_file .. '\\persistent-colorscheme'
else
  color_file = color_file .. '/persistent-colorscheme'
end
local M = {}

M.make_transparent = function()
  vim.cmd 'hi Normal guibg=NONE'
  vim.cmd 'hi NormalNC guibg=NONE'
  vim.cmd 'hi FoldColumn guibg=NONE'
  vim.cmd 'hi SignColumn guibg=NONE'
  vim.cmd 'hi LineNr guibg=NONE'
end

M.load_state = function()
  if vim.fn.filereadable(color_file) == 1 then
    local file = io.open(color_file, 'r')
    if file == nil then
      print 'Error opening state file'
      return
    end
    io.input(file)
    vim.cmd.colorscheme(io.read '*l')
    io.close(file)
  end
end

M.write_state = function(opts)
  local file = io.open(color_file, 'w')
  if file == nil then
    print 'Error opening state file'
    return
  end
  file:write(opts.colorscheme)
  file:close()
end

return M
