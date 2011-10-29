" NOTE: You must, of course, install the pss script
"       in your path.

" Location of the pss utility
if !exists("g:pssprg")
	let g:pssprg="pss -H --nocolor --column --noheading --nobreak"
endif

function! s:Pss(cmd, args)
    redraw
    echo "Searching ..."

    " If no pattern is provided, search for the word under the cursor
    if empty(a:args)
        let l:grepargs = expand("<cword>")
    else
        let l:grepargs = a:args
    end

    " Format, used to manage column jump
    if a:cmd =~# '-g$'
        let g:pssformat="%f"
    else
        let g:pssformat="%f:%l:%c:%m"
    end

    " backup grep program and format settings
    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat

    try
        let &grepprg=g:pssprg
        let &grepformat=g:pssformat
        silent execute a:cmd . " " . l:grepargs
    finally
        " restore orignal settings
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    if a:cmd =~# '^l'
        botright lopen
    else
        botright copen
    endif

    " TODO: Document this!
    exec "nnoremap <silent> <buffer> q :ccl<CR>"
    exec "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
    exec "nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>"
    exec "nnoremap <silent> <buffer> o <CR>"
    exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"

    " If highlighting is on, highlight the search keyword.
    if exists("g:psshighlight")
        let @/=a:args
        set hlsearch
    end

    redraw!
endfunction

command! -bang -nargs=* -complete=file Pss call s:Pss('grep<bang>',<q-args>)
