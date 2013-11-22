let g:search_pulse#initialized = 0

function! search_pulse#initialize()
    let gui_running = has('gui_running')

    " Color list:
    " http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
    " http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
    if exists('g:vim_search_pulse_color_list') &&
                \ type(g:vim_search_pulse_color_list) == 3
        let g:search_pulse#color_list = g:vim_search_pulse_color_list
    else
        if gui_running == 1
            let g:search_pulse#color_list = ['#3a3a3a', '#444444', '#4e4e4e',
                        \ '#585858', '#606060']
        else
            let g:search_pulse#color_list = [237, 238, 239, 240, 241]
        endif
    endif

    " Approximative pulse duration in milliseconds
    if exists('g:vim_search_pulse_duration') &&
                \ type(g:vim_search_pulse_duration) == 0
        let g:search_pulse#duration = g:vim_search_pulse_duration
    else
        let g:search_pulse#duration = 200
    endif

    " Mode can be cursor_line, pattern
    if !exists('g:vim_search_pulse_mode')
        let g:vim_search_pulse_mode = 'cursor_line'
    endif

    if gui_running
        let g:search_pulse#highlight_arg = 'guibg'
    else
        let g:search_pulse#highlight_arg = 'ctermbg'
    endif

    let g:search_pulse#oldc =
                \ synIDattr(synIDtrans(hlID('CursorLine')), 'bg')

    if g:search_pulse#oldc == -1
        let g:search_pulse#oldc = 'NONE'
    endif

    let g:search_pulse#iterator =
                \ g:search_pulse#color_list +
                \ reverse(copy(g:search_pulse#color_list))[1:]
    let g:search_pulse#sleep =
                \ g:search_pulse#duration /
                \ len(g:search_pulse#iterator)
    let g:search_pulse#initialized = 1
endfunction

" Will pulse the cursor line on first search match using / or ?
function! search_pulse#PulseFirst()
    let t = getcmdtype()

    if t == '/' || t == '?'
        return "\<cr>:call search_pulse#Pulse()\<cr>"
    endif

    return "\<cr>"
endfunction

function! search_pulse#NeedsInitialization()
    if g:search_pulse#initialized == 0
        return 1
    endif
    if exists('g:vim_search_pulse_color_list')
                \ && g:vim_search_pulse_color_list != g:search_pulse#color_list
        return 1
    endif
    if exists('g:vim_search_pulse_duration')
                \ && g:vim_search_pulse_duration != g:search_pulse#duration
        return 1
    endif

    return 0
endfunction

function! search_pulse#Pulse()
    if search_pulse#NeedsInitialization()
        call search_pulse#initialize()
    endif
    if g:vim_search_pulse_mode == 'pattern'
        call search_pulse#PulsePattern()
    elseif g:vim_search_pulse_mode == 'cursor_line'
        call search_pulse#PulseCursorLine()
    endif
endfunction

function! search_pulse#PulsePattern()
    let pos     = getpos('.')
    let pattern = '\%' . pos[1] . 'l\%' . pos[2] . 'c' . getreg('/')

    if &ignorecase == 1 || &smartcase == 1
        let pattern = pattern . '\c'
    endif

    " Open folds
    normal zv

    for c in g:search_pulse#iterator
        let match_id = search_pulse#SetPatternColor(c, pattern)
        redraw

        " In the loop, if a key is pressed,
        " removes match highlight and break
        if getchar(1) != 0
            call matchdelete(match_id)
            break
        endif

        execute 'sleep ' . g:search_pulse#sleep . 'm'
        call matchdelete(match_id)
    endfor
endfunction

function! search_pulse#PulseCursorLine()
    if search_pulse#IsLineTooLong()
        return
    endif
    if search_pulse#IsPatternOnTheSameLine()
        return
    endif

    " Open folds
    normal zv

    " Save the line we are on to avoid pulsing the same line if pattern is on
    " the same line.
    let g:vim_search_pulse_old_line = line('.')

    for c in g:search_pulse#iterator
        " In the loop, if a key is pressed,
        " restore old cursor line color and break
        if getchar(1) != 0
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
    execute 'highlight CursorLine ' . g:search_pulse#highlight_arg . '=' . a:c
endfunction

function! search_pulse#SetPatternColor(c, pattern)
    execute 'highlight SearchPulse ' . g:search_pulse#highlight_arg . '=' . a:c

    return matchadd('SearchPulse', a:pattern)
endfunction

" If the line has too many characters don't pulse, because it can be slow on
" very long lines.
function! search_pulse#IsLineTooLong()
    let cc = len(getline('.')) " Current line charecter count
    let ww = winwidth(0) " Current window width
    " Imagine you have wrapped lines, this is the line count
    let lc = ceil((cc * 1.0) / (ww * 1.0))

    return lc >= 3.0
endfunction

function! search_pulse#IsPatternOnTheSameLine()
    if !exists('g:vim_search_pulse_old_line')
        let g:vim_search_pulse_old_line = line('.')

        return 0
    endif

    return g:vim_search_pulse_old_line == line('.')
endfunction
