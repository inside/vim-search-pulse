let g:search_pulse#initialized = 0

function! search_pulse#initialize()
    " Color list:
    " http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
    " http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
    if exists('g:vim_search_pulse_color_list') &&
                \ type(g:vim_search_pulse_color_list) == 3
        let colorList = g:vim_search_pulse_color_list
    else
        let colorList = [237, 238, 239, 240, 241]
    endif

    " Approximative pulse duration in milliseconds
    if exists('g:vim_search_pulse_duration') &&
                \ type(g:vim_search_pulse_duration) == 0
        let duration = g:vim_search_pulse_duration
    else
        let duration = 200
    endif

    let g:search_pulse#oldc =
                \ synIDattr(synIDtrans(hlID('CursorLine')), 'bg')
    let g:search_pulse#iterator =
                \ colorList +
                \ reverse(copy(colorList))[1:]
    let g:search_pulse#sleep =
                \ duration /
                \ len(g:search_pulse#iterator)
    let g:search_pulse#initialized = 1
endfunction

" Will pulse the cursor line on first search match using / or ?
function! search_pulse#PulseFirst()
    let t = getcmdtype()

    if t == '/' || t == '?'
        return "\<cr>:call search_pulse#PulseCursorLine()\<cr>"
    endif

    return "\<cr>"
endfunction

function! search_pulse#PulseCursorLine()
    if g:search_pulse#initialized == 0
        call search_pulse#initialize()
    endif

    " Open folds
    normal zv

    for c in g:search_pulse#iterator
        let char = getchar(1)

        " In the loop, if a key is pressed,
        " restore old cursor line color and exit
        if char != 0
            call search_pulse#SetCursorLineColor(g:search_pulse#oldc)
            break
        endif

        call search_pulse#SetCursorLineColor(c)
        redraw
        execute 'sleep ' . g:search_pulse#sleep . 'm'
    endfor

    " Restore the old cursorline color
    call search_pulse#SetCursorLineColor(g:search_pulse#oldc)
endfunction

function! search_pulse#SetCursorLineColor(c)
    execute 'highlight CursorLine ctermbg=' . a:c
endfunction
