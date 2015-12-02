" File:        search_pulse.vim
" Maintainer:  Yann Thomas-Gérard <inside at gmail dot com>
" Version:     0.0.1
" License:     This file is placed in the public domain.

" Initial code from:
" https://github.com/LStinson/Vim/blob/master/plugin/pulse.vim
nnoremap
      \ <script>
      \ <Plug>Pulse <SID>Pulse
nnoremap
      \ <silent>
      \ <SID>Pulse :call search_pulse#Pulse()<cr>

if get(g:, 'vim_search_pulse_disable_auto_mappings') != 0
  finish
endif

nmap n n<Plug>Pulse
nmap N N<Plug>Pulse
nmap * *<Plug>Pulse
nmap # #<Plug>Pulse
" Pulses cursor line on first match
" when doing search with / or ?
cmap <silent> <expr> <enter> search_pulse#PulseFirst()
