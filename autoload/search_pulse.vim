function! search_pulse#PulseCursorLine()
    let oldc = synIDattr(synIDtrans(hlID('CursorLine')), 'bg')
    " Color list:
    " http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
    " http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
    let colorList = [
                \'237',
                \'238',
                \'239',
                \'240',
                \'241'
                \]
    " Approximative pulse duration in milliseconds
    let d = 80.0
    let reversed = reverse(copy(colorList))
    let iterator = colorList + reversed[1:]
    " Sleep between each iteration
    let s = float2nr(round(d / len(iterator))) . 'm'

    for c in iterator
        let char = getchar(1)

        " In the loop, if a key is pressed,
        " restore old cursor line color and exit
        if char != 0
            call search_pulse#SetCursorLineColor(oldc)
            break
        endif

        call search_pulse#SetCursorLineColor(c)
        redraw
        execute 'sleep '  . s . 'm'
    endfor

    " Restore the old cursorline color
    call search_pulse#SetCursorLineColor(oldc)
endfunction

function! search_pulse#SetCursorLineColor(c)
    execute 'highlight CursorLine ctermbg=' . a:c
endfunction
