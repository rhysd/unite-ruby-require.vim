# Search Ruby libraries and gems to require with unite.vim

This Vim plugin is a [unite.vim](https://github.com/Shougo/unite.vim) source
for searching paths for `require` in Ruby.
This plugin searches Ruby standard library paths, gem's default paths, and
bundler's local paths. Everything is done asynchronously, and also it caches.

## Usage

```vim
:Unite ruby/require
```

It may take time on the first run if you have many gem libraries, but they'll show up immediately when you try again, since unite-ruby-require caches the result.

If you wan't to clear the cache and re-calculate, type `<C-l>` in normal mode
in unite window by default. Check `h <Plug>(unite_redraw)` for more detail in
the unite core doc.

## Authors

* rhysd
* ujihisa

## License

GPL-3 or later

## Setting

(OPTIONAL) You can set ruby command to use for searching gems to
`g:unite_source_ruby_require_cmd`. By default unite-ruby-require will
look up from `$PATH`.

Example:

* rbenv users

      ```vim
      let g:unite_source_ruby_require_cmd = '$HOME/.rbenv/shims/ruby'
      ```

* manual install

      ```vim
      let g:unite_source_ruby_require_cmd = '$HOME/git/ruby/local/bin/ruby'
      ```

* jruby

      ```vim
      let g:unite_source_ruby_require_cmd = '/usr/bin/jruby'
      ```

Note that you don't have to specify it if you use `/usr/bin/ruby`.

## Screenshots

![rails](http://cache.gyazo.com/c421f4d4828209e1881dbc45de45fa42.png)

![search require paths with 'core_ext'](https://raw.github.com/rhysd/unite-ruby-require.vim/master/screen.jpg)
