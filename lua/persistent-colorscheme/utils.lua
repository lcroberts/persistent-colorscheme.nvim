local vim = vim
local M = {}

local state_file = vim.fn.stdpath 'data'
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  state_file = state_file .. '\\persistent-colorscheme'
else
  state_file = state_file .. '/persistent-colorscheme'
end

-- Reads the cached file and returns a table containing 2 keys.
-- transparent - a boolean for whether or not transparency is enabled
-- colorscheme - the name of the last used colorscheme
---@return opts table A table containing the persisted opts.
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

-- Reads the previous colorscheme and transparency status and returns neovim to that state.
M.load_state = function()
  if vim.fn.filereadable(state_file) == 0 then
    M.write_state()
    return
  end
  opts = M.parse_file()
  vim.g.transparent_enabled = opts.transparent
  pcall(vim.cmd.colorscheme, opts.colorscheme)
end

-- Persists the current colorscheme and transparency status
M.write_state = function()
  local opts = {}
  opts.colorscheme = vim.g.colors_name
  opts.transparent = vim.g.transparent_enabled
  local file = io.open(state_file, 'w')
  if file == nil then
    print 'Error opening state file'
    return
  end
  file:write(vim.json.encode(opts))
  file:close()
end

return M
