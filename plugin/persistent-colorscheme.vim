if !has('nvim')  | finish | endif

if exists('g:loaded_transparent') | finish | endif

let g:loaded_transparent = 1

function! OnTransparentGroupsChanged(d, k, z)
   call luaeval('require("persistent-colorscheme").handle_groups_changed(_A)', a:z)
endfunction

call dictwatcheradd(g:, 'transparent_groups', 'OnTransparentGroupsChanged')

augroup transparent
    autocmd!
    autocmd VimEnter,ColorScheme,FileType * lua require('persistent-colorscheme').make_transparent()
    command -bar -nargs=0 TransparentEnable  lua require('persistent-colorscheme').toggle(true)
    command -bar -nargs=0 TransparentDisable lua require('persistent-colorscheme').toggle(false)
    command -bar -nargs=0 TransparentToggle  lua require('persistent-colorscheme').toggle()
augroup END
