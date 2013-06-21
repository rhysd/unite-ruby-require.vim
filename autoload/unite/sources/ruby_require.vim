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
let s:C = s:V.import('System.Cache')

let s:helper_path = printf(
      \ '%s%sruby_helper.rb',
      \ expand('<sfile>:p:h'),
      \ s:F.separator())
let s:ramcache = ['undefined']

function! unite#sources#ruby_require#define()
  let ok = g:unite_source_ruby_require_cmd !=# '' && s:P.is_available()
  return ok ? s:source : {}
endfunction

function! s:source.gather_candidates(args, context)
  if s:ramcache == ['undefined']
    let s:ramcache = s:_slurp_cache()
  endif
  if a:context.is_async && !empty(s:ramcache)
    let a:context.is_async = 0
    return s:ramcache
  elseif a:context.is_redraw
    let s:ramcache = []
    let a:context.is_async = 1
  endif
  return s:source.async_gather_candidates(a:args, a:context)
endfunction

function! s:source.async_gather_candidates(args, context)
  let cmd = printf('%s %s', g:unite_source_ruby_require_cmd, s:helper_path)
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
    call s:_spit_cache(s:ramcache)
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

function! s:_spit_cache(list)
  let xs = map(copy(a:list), 'string(v:val)')
  call s:C.writefile(g:unite_data_directory, 'ruby_require', xs)
endfunction

function! s:_slurp_cache()
  let list = s:C.readfile(g:unite_data_directory, 'ruby_require')
  return map(list, 'eval(v:val)')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
