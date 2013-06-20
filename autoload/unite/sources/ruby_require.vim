let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_ruby_require_cmd =
      \ get(g:, 'unite_source_ruby_require_cmd', 'ruby')

let s:source = {
      \ 'name': 'ruby/require',
      \ 'description': 'Ruby library to require',
      \ 'default_action': {'common': 'insert'},
      \ }

let s:helper_path = printf('%s/ruby_helper.rb', expand('<sfile>:p:h'))
let s:P = vital#of('unite-ruby-require.vim').import('ProcessManager')

function! unite#sources#ruby_require#define()
  let ok = g:unite_source_ruby_require_cmd !=# '' && s:P.is_available()
  return ok ? s:source : {}
endfunction

function! s:source.async_gather_candidates(args, context)
  let cmd = printf('%s %s', g:unite_source_ruby_require_cmd, s:helper_path)
  call s:P.touch('unite-ruby-require', cmd)
  let [out, err, type] = s:P.read('unite-ruby-require', ['$'])
  call unite#util#print_error(err)
  if type ==# 'timedout'
    return s:_format(out)
  else " matched
    let a:context.is_async = 0
    call s:P.stop('unite-ruby-require')
    return s:_format(out)
  endif
endfunction

function! s:_format(out)
  let require_list = split(a:out, "\n")
  return map(require_list, '{
        \ "word": printf("require %s", string(v:val)),
        \ "abbr": v:val,
        \ }')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
