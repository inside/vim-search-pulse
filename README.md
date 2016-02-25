# The vim search pulse plugin: easily locate the cursor after a search

## Description

When you perform a search, the cursor jumps to the closest match. It's often
hard to locate it's new position. With this plugin the cursor line (by default)
or the search pattern will "pulse" thus requiring your eyes attention.

For the cursor line to be set only in the active window you may want to install
this plugin: https://github.com/vim-scripts/CursorLineCurrentWindow

Activate the cursor line highlighing by putting `set cursorline` in your .vimrc
file.

### Cursor line pulse animation:
![cursor line pulse](http://i.imgur.com/ukZuti2.gif)

### Pattern pulse animation:
![pattern pulse](http://i.imgur.com/jFyjW3f.gif)

## Installation

Use pathogen or a pathogen compatible plugin manager.

## Configuration

Sets whether the cursor line pulses (default is cursor_line):

    let g:vim_search_pulse_mode = 'cursor_line'

or just the search pattern:

    let g:vim_search_pulse_mode = 'pattern'

If you want to set your own mappings, do:

    let g:vim_search_pulse_disable_auto_mappings = 1

Otherwise the plugin will do the following for you:

    nmap n n<Plug>Pulse
    nmap N N<Plug>Pulse
    nmap * *<Plug>Pulse
    nmap # #<Plug>Pulse
    " Pulses cursor line on first match
    " when doing search with / or ?
    cmap <silent> <expr> <enter> search_pulse#PulseFirst()

The pulse duration is 200 milliseconds by default. You can set your own using
the following global variable. For example:

    let g:vim_search_pulse_duration = 400

The colors used by the pulse are `[237, 238, 239, 240, 241]` (gray scale) by
default. A color map can be found at:
http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html

You can set your own and as many as you want using the following global
variable. For example (green scale):

    let g:vim_search_pulse_color_list = [22, 28, 34, 40, 46]

If you are using gvim, these are the default colors:

    `['#3a3a3a', '#444444', '#4e4e4e', '#585858', '#606060']`

To disable/enable set the value of `g:vim_search_pulse_disable` to 0 or 1

To execute arbitrary commands before and after pulse runs, use these autocmds:

    autocmd User PrePulse
    autocmd User PostPulse

For example, to turn on `cursorcolumn` during the pulse and then off right after:

    augroup Pulse
        autocmd! User PrePulse
        autocmd! User PostPulse
        autocmd  User PrePulse  set cursorcolumn
        autocmd  User PostPulse set nocursorcolumn
    augroup END

This functionality requires Vim 7.3.438 or newer.

## Integration with the incsearch.vim plugin

[incsearch.vim](https://github.com/haya14busa/incsearch.vim) provides a very
nice improved incremental searching. With a little configuration, it can
work with the vim search pulse:

    " incsearch and vim search pulse
    let g:vim_search_pulse_disable_auto_mappings = 1
    let g:incsearch#auto_nohlsearch = 1
    map / <Plug>(incsearch-forward)
    map ? <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)

    " Next or previous match is followed by a Pulse
    map n <Plug>(incsearch-nohl-n)<Plug>Pulse
    map N <Plug>(incsearch-nohl-N)<Plug>Pulse
    map * <Plug>(incsearch-nohl-*)<Plug>Pulse
    map # <Plug>(incsearch-nohl-#)<Plug>Pulse
    map g* <Plug>(incsearch-nohl-g*)<Plug>Pulse
    map g# <Plug>(incsearch-nohl-g#)<Plug>Pulse

    " Pulses the first match after hitting the enter keyan
    autocmd! User IncSearchExecute
    autocmd User IncSearchExecute :call search_pulse#Pulse()

## Integration with the vim-asterisk plugin

[vim-asterisk](https://github.com/haya14busa/vim-asterisk) provides improved
star motions. Here's the configuration:

    let g:vim_search_pulse_disable_auto_mappings = 1

    nmap * <Plug>(asterisk-*)<Plug>Pulse
    nmap # <Plug>(asterisk-#)<Plug>Pulse
    nmap n n<Plug>Pulse
    nmap N N<Plug>Pulse
    " Pulses cursor line on first match
    " when doing search with / or ?
    cmap <silent> <expr> <enter> search_pulse#PulseFirst()

## Known bugs

### MacVim

* A redraw bug appears on MacVim when using this plugin, the
  [vim-bling](https://github.com/ivyl/vim-bling) or any plugin using a redraw
  loop. It's not plugin, but MacVim related.

  There's a [video describing the bug](https://www.youtube.com/watch?v=miz_Ut8T4jk)
  and a [discussion about it](https://groups.google.com/forum/#!topic/vim_mac/z-IBAFHbQak).

## Credits

This plugin is inspired by:

* https://github.com/LStinson/Vim/blob/master/plugin/pulse.vim
* https://github.com/ivyl/vim-bling from which I borrowed some ideas
* http://redd.it/1o7t2a

The animated gif was created using http://www.cockos.com/licecap/

Thanks to everyone who participated in making this plugin better.
