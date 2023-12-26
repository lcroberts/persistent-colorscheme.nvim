local vim = vim
local M = {}

local defaults = {
  --- @type string
  default_colorscheme = 'default',
}

M.setup = function(options)
  local opts = vim.tbl_deep_extend('keep', options or {}, defaults)
  vim.cmd.colorscheme(opts.default_colorscheme)

  local color_file = vim.fn.stdpath 'data'
  if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
    color_file = color_file .. '\\persistent-colorscheme'
  else
    color_file = color_file .. '/persistent-colorscheme'
  end

  if vim.fn.filereadable(color_file) == 1 then
    local file = io.open(color_file, 'r')
    io.input(file)
    vim.cmd.colorscheme(io.read '*l')
    io.close(file)
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
