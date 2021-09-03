"============================================================================
"File:        pgsanity.vim
"Description: Syntax checking plugin for syntastic
"Maintainer:  Callum Trayner <callum@treshna.com>
"License:     MIT
"============================================================================

if exists('g:loaded_syntastic_sql_pgsanity_checker')
    finish
endif
let g:loaded_syntastic_sql_pgsanity_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_sql_pgsanity_GetHighlightRegex(i)
    let term = matchstr(a:i['text'], '\m at or near "\zs[^"]\+\ze"')
    return term !=# '' ? '\V\<' . escape(term, '\') . '\>' : ''
endfunction

function! SyntaxCheckers_sql_pgsanity_IsAvailable() dict
    if !executable(self.getExec())
        return 0
    endif
    return 1
endfunction

function! SyntaxCheckers_sql_pgsanity_GetLocList() dict
    let makeprg = self.makeprgBuild({})

    let errorformat =
        \ '%Eline %l: ERROR: %m,' .
        \ '%C %m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'returns': [0, 1] })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'sql',
    \ 'name': 'pgsanity',
    \ 'exec': 'pgsanity'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
