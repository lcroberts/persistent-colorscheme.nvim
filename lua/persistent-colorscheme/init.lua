local vim = vim
local opt = vim.opt
local M = {}

M.setup = function()
  local color_file = vim.fn.stdpath 'data' .. '/persistent-colorscheme'
  if vim.fn.filereadable(color_file) == 1 then
    local f = io.open(color_file, 'r')
    io.input(f)
    vim.cmd.colorscheme(io.read '*l')
    io.close(f)
  else
    vim.cmd.colorscheme 'tokyonight-night'
  end

  if vim.fn.filewritable(color_file) == 0 then
    os.execute('touch ' .. color_file)
  end

  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    group = vim.api.nvim_create_augroup('ColorSchemePersist', { clear = true }),
    callback = function()
      local file = io.open(color_file, 'w')
      file:write(vim.g.colors_name)
      file:close()
    end,
  })
end

M.test = function() end

return M
