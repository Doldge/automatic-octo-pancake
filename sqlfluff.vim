"============================================================================
"File:        pgsanity.vim
"Description: Syntax checking plugin for syntastic
"Maintainer:  Callum Trayner <callum@treshna.com>
"License:     MIT
"============================================================================

" L:  23 | P:  14 | L010 | Inconsistent capitalisation of keywords.
if exists('g:loaded_syntastic_sql_sqlfluff_checker')
    finish
endif
let g:loaded_syntastic_sql_sqlfluff_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_sql_pgsanity_GetHighlightRegex(i)
    let term = matchstr(a:i['text'], '\m at or near "\zs[^"]\+\ze"')
    return term !=# '' ? '\V\<' . escape(term, '\') . '\>' : ''
endfunction

function! SyntaxCheckers_sql_sqlfluff_IsAvailable() dict
    if !executable(self.getExec())
        return 0
    endif
    return 1
endfunction

function! SyntaxCheckers_sql_sqlfluff_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'args_before': 'lint --dialect postgres --ignore parsing', 'post_args_after': '| tr -s " " ' })

    let errorformat =
        \ '%WL: %l \| P: %c \| %m,' .
        \ '%C | %m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'returns': [0, 65],
        \ 'postprocess': ['compressWhitespace']
        \ })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'sql',
    \ 'name': 'sqlfluff',
    \ 'exec': 'sqlfluff'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
