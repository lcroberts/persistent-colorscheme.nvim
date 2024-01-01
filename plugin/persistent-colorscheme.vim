if !has('nvim')  | finish | endif

if exists('g:loaded_transparent') | finish | endif

let g:loaded_transparent = 1

function! OnTransparentGroupsChanged(d, k, z)
   call luaeval('require("persistent-colorscheme").handle_groups_changed(_A)', a:z)
endfunction

call dictwatcheradd(g:, 'transparent_groups', 'OnTransparentGroupsChanged')
