stdlibs = $LOAD_PATH.grep(/ruby\/\d\.\d\.\d$/).
  map {|l|
    r = /^#{l}\/(.+)\.rb$/
    Dir.glob("#{l}/**/*.rb").map {|p| p[r, 1] }.compact
  }.
  flatten.sort
bundler_paths = [(require 'bundler'; Bundler.bundle_path.to_s)] rescue []
gemlibs = (bundler_paths + Gem.default_path).
  flatten.
  map {|p|
    r = /^#{p}\/.+\/lib\/(.+)\.rb$/
    Dir.glob("#{p}/**/lib/**/*.rb").map {|g| g[r, 1] }.compact
  }.
  flatten.sort.uniq
#puts stdlibs + gemlibs
p [stdlibs.size, gemlibs.size]
