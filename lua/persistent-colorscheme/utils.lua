local vim = vim
local M = {}

local state_file = vim.fn.stdpath 'data'
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  state_file = state_file .. '\\persistent-colorscheme'
else
  state_file = state_file .. '/persistent-colorscheme'
end

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

M.make_transparent = function()
  for _, x in ipairs(vim.g.transparent_groups) do
    local ok, prev_attributes = pcall(vim.api.nvim_get_hl, 0, { name = x })
    if ok and (prev_attributes.background or prev_attributes.bg or prev_attributes.ctermbg) then
      local attributes = vim.tbl_extend('force', prev_attributes, { bg = 'NONE', ctermbg = 'NONE' })
      attributes[true] = nil
      vim.api.nvim_set_hl(0, x, attributes)
    end
  end
end

return M
