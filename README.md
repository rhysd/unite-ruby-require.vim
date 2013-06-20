# Search Ruby libraries and gems to require with unite.vim

This Vim plugin is a [unite.vim](https://github.com/Shougo/unite.vim) source
for searching paths for `require` in Ruby.
This plugin searches Ruby standard library paths, gem's default paths, and
bundler's local paths.

## Usage

```vim
:Unite ruby/require
```

## Authors

* rhysd
* ujihisa

## License

TBD

## Setting

(OPTIONAL) You can set ruby command to use for searching gems to
`g:unite_source_ruby_require_ruby_command`. By default unite-ruby-require will
look up from `$PATH`.

Example:

```vim
" This is for rbenv users
let g:unite_source_ruby_require_ruby_command = '$HOME/.rbenv/shims/ruby'
```

## Screenshot

![search require paths with 'core_ext'](https://raw.github.com/rhysd/unite-ruby-require.vim/master/screen.jpg)
