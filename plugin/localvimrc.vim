" Name:         localvimrc.vim
" Version:      $Id$
" Author:       Markus Braun
" Description:  Search local vimrc files (".lvimrc") in the tree (root dir
"               up to current dir) and load them.
" Installation: Put this file into your plugin directory (~/.vim/plugin)
" Licence:      This program is free software; you can redistribute it and/or
"               modify it under the terms of the GNU General Public License.
"               See http://www.gnu.org/copyleft/gpl.txt

" Section: Plugin header {{{1
" guard against multiple loads {{{2
if (exists("g:loaded_localvimrc") || &cp)
  finish
endif
let g:loaded_localvimrc = "$Revision$"

" check for correct vim version {{{2
if version < 700
  finish
endif

" define default local vimrc file name {{{2
if (!exists("g:localvimrc_name"))
  let g:localvimrc_name = ".lvimrc"
endif

" define default "search depth" {{{2
if (!exists("g:localvimrc_count"))
  let g:localvimrc_count = -1
endif

" Section: Functions {{{1
" Function: s:localvimrc {{{2
"
" search all local vimrc files from current directory up to root directory and
" source them in reverse order.
"
function! s:localvimrc() 
  " directory of current file (correctly escaped)
  let l:directory = escape(expand("%:p:h"), ' ~|!"$%&()=?{[]}+*#'."'")

  " generate a list of all local vimrc files along path to root
  let l:rcfiles = findfile(g:localvimrc_name, l:directory . ";", -1)

  " shrink list of found files
  let l:rcfiles = l:rcfiles[1:g:localvimrc_count]

  " source all found local vimrc files along path from root (reverse order)
  for l:rcfile in reverse(l:rcfiles)
    if filereadable(l:rcfile)
      exec 'source ' . escape(l:rcfile, ' ~|!"$%&()=?{[]}+*#'."'")
      "echom 'sourced ' . l:rcfile
    endif
  endfor
endfunction

" Section: Autocmd setup {{{1
if has("autocmd")
  augroup localvimrc                                                                                                                                                                                                 
    autocmd!
    " call s:localvimrc() when creating ore reading any file
    autocmd BufNewFile,BufRead * call s:localvimrc()
  augroup END
endif

" vim600: set foldmethod=marker
