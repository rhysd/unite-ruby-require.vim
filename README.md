# Search ruby gems to require with unite.vim

##Usage

```
:Unite ruby/require
```

##Setting

You can set ruby command used in searching gems to `g:unite_source_ruby_require_ruby_command`.

Example:

```
" This is for rbenv user
let g:unite_source_ruby_require_ruby_command = '$HOME/.rbenv/shims/ruby'
```
