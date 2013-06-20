let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_ruby_require_ruby_command =
      \ get(g:, 'unite_source_ruby_require_ruby_command', 'ruby')

let s:source = {
      \ "name": "ruby/require",
      \ "description": "Ruby library to require",
      \ "default_action": {"common": "require"},
      \ "action_table": {},
      \ }

function! unite#sources#ruby_require#define()
    return g:unite_source_ruby_require_ruby_command ==# '' ? {} : s:source
endfunction

function! s:source.gather_candidates(args, context)
  let x = (g:unite_source_ruby_require_ruby_command .
        \ ' -e '.
        \ '''begin; require "bundler"; b=[Bundler::bundle_path.to_s]; rescue; b=[]; end;'.
        \ 'puts $LOAD_PATH.select{|l| l=~/ruby\/\d\.\d\.\d$/ }.map{|l| Dir.glob(l+"/**/*").map{|p| p=~/#{l}\/(.+)\.rb$/; $1}}.flatten!.compact!.sort!'.
        \ ' + (b+Gem::default_path).map{|p| Dir.glob(p+"/**/*.rb").map{|g| g=~/#{p}\/.+\/lib\/(.+)\.rb$/; $1 }}.flatten!.compact!.sort!.uniq!'.
        \ '''')
  let require_list = split(unite#util#system(x), "\n")

  return map(require_list, "{
        \ 'word': v:val,
        \ 'is_multiline': 1,
        \ }")
endfunction

let s:source.action_table.require = {
      \ 'description' : 'require ruby gems'
      \ }

function! s:source.action_table.require.func(candidate)
  execute 'put!' '=' 'require ''''' . a:candidate.word . ''''''''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
