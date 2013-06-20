let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_ruby_require_cmd =
      \ get(g:, 'unite_source_ruby_require_cmd', 'ruby')

let s:source = {
      \ "name": "ruby/require",
      \ "description": "Ruby library to require",
      \ "default_action": {"common": "insert"},
      \ "action_table": {},
      \ }

let s:helper_path = printf('%s/ruby_helper.rb', expand('<sfile>:p:h'))

function! unite#sources#ruby_require#define()
    return g:unite_source_ruby_require_cmd ==# '' ? {} : s:source
endfunction

function! s:source.gather_candidates(args, context)
  let cmd = printf('%s %s', g:unite_source_ruby_require_cmd, s:helper_path)
  let require_list = split(unite#util#system(cmd), "\n")

  return map(require_list, "{
        \ 'word': printf(\"require '%s'\", v:val),
        \ 'abbr': v:val,
        \ 'is_multiline': 1,
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
