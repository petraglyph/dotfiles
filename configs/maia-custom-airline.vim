" Custom Maia Color Scheme for Airline
"   Penn Bauman <me@pennbauman.com>
"   https://github.com/pennbauman/dotfiles


" Color palette
let s:yellow = { "cterm": 3, "gui": "#f0c07e" }
let s:purple = { "cterm": 5, "gui": "#b56ea7" }
let s:green = { "cterm": 2, "gui": "#2eb398" }
let s:blue = { "cterm": 4, "gui": "#4ea2c1" }
let s:magenta = { "cterm": 1, "gui": "#db5b5b" }
let s:orange = { "cterm": 14, "gui": "#b5e4a7" }

let s:light_grey = { "cterm": 7, "gui": "#bcbcbc" }
let s:dark_grey = { "cterm": 8, "gui": "#5f5f5f" }
let s:darker_grey = { "cterm": 0, "gui": "#444444" }
let s:light_charcoal = { "cterm": 19, "gui": "#303030" }
let s:charcoal = { "cterm": 19, "gui": "#262626" }
let s:none = { "cterm":"none", "gui":""}

function! s:add(fg, bg, style)
  return [ a:fg["gui"], a:bg["gui"], a:fg["cterm"], a:bg["cterm"], a:style ]
endfunction

let s:palette = {}

" Normal mode
let s:palette.normal = {
      \   'airline_a': s:add(s:charcoal, s:green, 'bold'),
      \   'airline_b': s:add(s:light_grey, s:dark_grey, 'none'),
      \   'airline_c': s:add(s:green, s:none, 'none'),
      \   'airline_x': s:add(s:green, s:light_charcoal, 'none'),
      \   'airline_y': s:add(s:light_grey, s:none, 'none'),
      \   'airline_z': s:add(s:charcoal, s:green, 'bold'),
      \ }
let s:palette.normal_modified = {
     \   'airline_c': s:add(s:blue, s:none, 'none'),
      \ }


" Insert mode
let s:palette.insert = {
      \   'airline_a': s:add(s:charcoal, s:yellow, 'bold'),
      \   'airline_b': s:add(s:light_grey, s:dark_grey, 'none'),
      \   'airline_c': s:add(s:yellow, s:none, 'none'),
      \   'airline_x': s:add(s:yellow, s:light_charcoal, 'none'),
      \   'airline_y': s:add(s:light_grey, s:none, 'none'),
      \   'airline_z': s:add(s:charcoal, s:yellow, 'bold'),
      \ }
let s:palette.insert_modified = {
      \   'airline_c': s:add(s:blue, s:none, 'none'),
      \ }

" Command
let s:palette.commandline = {
      \   'airline_a': s:add(s:charcoal, s:blue, 'bold'),
      \   'airline_b': s:add(s:light_grey, s:dark_grey, 'none'),
      \   'airline_c': s:add(s:blue, s:none, 'none'),
      \   'airline_x': s:add(s:blue, s:light_charcoal, 'none'),
      \   'airline_y': s:add(s:light_grey, s:none, 'none'),
      \   'airline_z': s:add(s:charcoal, s:blue, 'bold'),
      \ }

" Replace mode
let s:palette.replace = {
      \   'airline_a': s:add(s:charcoal, s:magenta, 'bold'),
      \   'airline_b': s:add(s:light_grey, s:dark_grey, 'none'),
      \   'airline_c': s:add(s:magenta, s:none, 'none'),
      \   'airline_x': s:add(s:magenta, s:light_charcoal, 'none'),
      \   'airline_y': s:add(s:light_grey, s:none, 'none'),
      \   'airline_z': s:add(s:charcoal, s:magenta, 'bold'),
      \ }
let s:palette.replace_modified = {
      \   'airline_c': s:add(s:blue, s:none, 'none'),
      \ }

" Visual mode
let s:palette.visual = {
      \   'airline_a': s:add(s:charcoal, s:purple, 'bold'),
      \   'airline_b': s:add(s:light_grey, s:dark_grey, 'none'),
      \   'airline_c': s:add(s:purple, s:none, 'none'),
      \   'airline_x': s:add(s:purple, s:light_charcoal, 'none'),
      \   'airline_y': s:add(s:light_grey, s:none, 'none'),
      \   'airline_z': s:add(s:charcoal, s:purple, 'bold'),
      \ }
let s:palette.visual_modified = {
      \   'airline_c': s:add(s:blue, s:none, 'none'),
      \ }

" Inactive window
let s:IA = s:add(s:light_grey, s:none, 'none')
let s:palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let s:palette.inactive_modified = {
      \   'airline_c': s:add(s:orange, s:none, 'none'),
      \ }

" CtrlP
if get(g:, 'loaded_ctrlp', 0)
  let s:palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
        \ s:add(s:yellow, s:dark_grey, 'none'),
        \ s:add(s:yellow, s:none, 'none'),
        \ s:add(s:charcoal, s:blue, 'bold') )
endif

let g:airline#themes#maia_custom#palette = s:palette
