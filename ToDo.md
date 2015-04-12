* add relative paths like `require './hoge'`
* doc
* after unite core includes ConcurrentProcess by upgrading vital, remove vital from this plugin
* This plugin caches at first time but it's possibly wrong.
    - when new gems are installed, they aren't reflected in candidates.
      It should cache `gem list` and check the new gems are installed or not
    - bundler gems change when a project changes
