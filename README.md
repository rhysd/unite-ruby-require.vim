# Search Ruby gems to require with unite.vim

This Vim plugin is a [unite.vim](https://github.com/Shougo/unite.vim) source for searching paths to require in Ruby.
This plugin searches gem's default paths and bundler's local paths.

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

Searching require-paths with a word, `core_ext`.
After choosing `active_support/core_ext`, typing `<CR>` appends `require 'active_support/core_ext'` to a line under the cursor.

![search require paths with 'core_ext'](https://raw.github.com/rhysd/unite-ruby-require.vim/master/screen.jpg)
