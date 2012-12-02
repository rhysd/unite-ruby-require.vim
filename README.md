# Search Ruby libraries and gems to require with unite.vim

This Vim plugin is a [unite.vim](https://github.com/Shougo/unite.vim) source for searching paths to require in Ruby.
This plugin searches Ruby standard library paths, gem's default paths and bundler's local paths.

##Usage

```
:Unite ruby/require
```

##Setting

You can set ruby command used in searching gems to `g:unite_source_ruby_require_ruby_command`.

Example:

```VimL
" This is for rbenv user
let g:unite_source_ruby_require_ruby_command = '$HOME/.rbenv/shims/ruby'
```

##Screenshot

Searching require-paths with a word, `uri`.
After choosing `open-uri`, typing `<CR>` appends `require 'open-uri'` to a line under the cursor.

![search require paths with 'core_ext'](https://raw.github.com/rhysd/unite-ruby-require.vim/master/screen.jpg)
