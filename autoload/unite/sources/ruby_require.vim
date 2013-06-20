let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_ruby_require_cmd =
      \ get(g:, 'unite_source_ruby_require_cmd', 'ruby')

let s:source = {
      \ 'name': 'ruby/require',
      \ 'description': 'Ruby library to require',
      \ 'default_action': {'common': 'insert'},
      \ }

let s:V = vital#of('unite-ruby-require.vim')
let s:P = s:V.import('ProcessManager')
let s:F = s:V.import('System.Filepath')

let s:helper_path = printf(
      \ '%s%sruby_helper.rb',
      \ expand('<sfile>:p:h'),
      \ s:F.separator())
echomsg string(['helper_path', s:helper_path])
let s:ramcache = []

function! unite#sources#ruby_require#define()
  let ok = g:unite_source_ruby_require_cmd !=# '' && s:P.is_available()
  return ok ? s:source : {}
endfunction

function! s:source.async_gather_candidates(args, context)
  "if !a:context.is_redraw && !empty(s:ramcache)
  "  return s:ramcache
  "endif
  let cmd = printf('%s %s', g:unite_source_ruby_require_cmd, s:helper_path)
  echomsg string(['cmd', cmd])
  call s:P.touch('unite-ruby-require', cmd)
  let [out, err, type] = s:P.read('unite-ruby-require', ['$'])
  call unite#util#print_error(err)
  if type ==# 'timedout'
    let formatted = s:_format(out)
    let s:ramcache += formatted
    return formatted
  else " matched
    let a:context.is_async = 0
    call s:P.stop('unite-ruby-require')
    let formatted = s:_format(out)
    let s:ramcache += formatted
    return formatted
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
