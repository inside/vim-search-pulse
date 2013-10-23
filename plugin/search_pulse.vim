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
