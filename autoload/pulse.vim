function! pulse#PulseCursorLine()
    " Color list:
    " http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
    let colorList = [
                \'237',
                \'238',
                \'239',
                \'240',
                \'241'
                \]
    " Approximative pulse duration in milliseconds
    let d = 80.0
    " Sleep between each iteration
    let s = float2nr(round(d / len(colorList))) . 'm'

    for pulse in colorList
        execute 'highlight CursorLine ctermbg=' . pulse
        redraw
        execute 'sleep '  . s . 'm'
    endfor
    for pulse in reverse(copy(colorList))
        execute 'highlight CursorLine ctermbg=' . pulse
        redraw
        execute 'sleep '  . s . 'm'
    endfor

    " Restore my default solarized params
    highlight CursorLine ctermbg=0
endfunction
