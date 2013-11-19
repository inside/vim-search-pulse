" File:        search_pulse.vim
" Maintainer:  Yann Thomas-Gérard <inside at gmail dot com>
" Version:     0.0.1
" License:     This file is placed in the public domain.

" Initial code from:
" https://github.com/LStinson/Vim/blob/master/plugin/pulse.vim
nnoremap
            \ <script>
            \ <Plug>PulseCursorLine
            \ <SID>PulseCursorLine
nnoremap
            \ <silent>
            \ <SID>PulseCursorLine
            \ :call search_pulse#PulseCursorLine()<cr>
cnoremap
            \ <script>
            \ <Plug>PulseFirst
            \ <SID>PulseFirst
cnoremap
            \ <silent>
            \ <expr>
            \ <SID>PulseFirst
            \ search_pulse#PulseFirst()

" Set a global variable (not autoloaded) to track the line position
let g:vim_search_pulse_old_line = line('.')

if exists('g:vim_search_pulse_set_mappings') == 0 ||
            \ (exists('g:vim_search_pulse_set_mappings') == 1 &&
            \ g:vim_search_pulse_set_mappings != 0)
    nmap n n<Plug>PulseCursorLine
    nmap N N<Plug>PulseCursorLine
    nmap * *<Plug>PulseCursorLine
    nmap # #<Plug>PulseCursorLine
    " Pulses cursor line on first match
    " when doing search with / or ?
    cmap <enter> <Plug>PulseFirst
endif
