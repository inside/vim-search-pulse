" File:        search_pulse.vim
" Maintainer:  Yann Thomas-Gérard <inside at gmail dot com>
" Version:     0.0.1
" License:     This file is placed in the public domain.

" Initial code from:
" https://github.com/LStinson/Vim/blob/master/plugin/pulse.vim
nnoremap <silent>n nzv:call search_pulse#PulseCursorLine()<cr>
nnoremap <silent>N Nzv:call search_pulse#PulseCursorLine()<cr>
