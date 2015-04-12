let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_ruby_require_cmd =
      \ get(g:, 'unite_source_ruby_require_cmd', 'ruby')

let s:source = {
      \ 'name': 'ruby/require',
      \ 'description': 'Ruby library to require',
      \ 'default_action': {'common': 'insert'},
      \ }

let s:V = vital#of('unite_ruby_require')
let s:CP = s:V.import('ConcurrentProcess')
let s:F = s:V.import('System.Filepath')
let s:C = s:V.import('System.Cache')

let s:helper_path = printf(
      \ '%s%sruby_helper.rb',
      \ expand('<sfile>:p:h'),
      \ s:F.separator())
let s:ramcache = ['undefined']

function! unite#sources#ruby_require#define()
  let ok = g:unite_source_ruby_require_cmd !=# '' && s:CP.is_available()
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
  let cmd = [g:unite_source_ruby_require_cmd, s:helper_path]
  let label = s:CP.of(cmd, '', [
        \ ['*read-all*', 'x']])
  let [out, err] = s:CP.consume(label, 'x')
  if err !=# ''
    call unite#util#print_error(err)
  endif

  if !s:CP.is_done(label, 'x')
    let formatted = s:_format(out)
    let s:ramcache += formatted
    return formatted
  else
    let a:context.is_async = 0
    call s:CP.shutdown(label)
    let formatted = s:_format(out)
    let s:ramcache += formatted
    call s:_spit_cache(s:ramcache)
    return formatted
  endif
endfunction

function! s:_format(out)
  let require_list = split(a:out, "\r\\?\n")
  return map(require_list, '{
        \ "word": printf("require %s", string(v:val)),
        \ "abbr": v:val,
        \ }')
endfunction

function! s:_spit_cache(list)
  let xs = map(copy(a:list), 'string(v:val)')
  call s:C.writefile(unite#get_data_directory(), 'ruby_require', xs)
endfunction

function! s:_slurp_cache()
  let list = s:C.readfile(unite#get_data_directory(), 'ruby_require')
  return map(list, 'eval(v:val)')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
