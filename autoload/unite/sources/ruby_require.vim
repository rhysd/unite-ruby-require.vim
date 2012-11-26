scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_ruby_require_ruby_command = get(g:, 'unite_source_ruby_require_ruby_command', 'ruby')
let s:source = {
            \ "name" : "ruby/require",
            \ "description" : "Ruby library to require",
            \ "action_table" : {},
            \ }

function! unite#sources#ruby_require#define()
    return g:unite_source_ruby_require_ruby_command=='' ? {} : s:source
endfunction

function! s:source.gather_candidates(args, context)
    let require_list = split(
          \ system(g:unite_source_ruby_require_ruby_command .
          \ ' -e ''puts Gem::default_path.map{|p| Dir.glob(p+"/**/*.rb").to_a.map{|g| g=~/#{p}\/.+\/lib\/(.+).rb$/; $1 }}.flatten!.compact!.sort!''')
          \ , "\n")

    if v:shell_error
        return []
    endif

    return map(require_list, "{
                \ 'word' : v:val,
                \ 'is_multiline' : 1,
                \ }")
endfunction

let s:source.action_table.require = {
            \ 'description' : 'require ruby gems'
            \ }

let &cpo = s:save_cpo
unlet s:save_cpo
