stdlibs = $LOAD_PATH.grep(/ruby\/\d\.\d\.\d$/).
  map {|p|
    r = /^#{p}\/(.+)\.rb$/
    Dir.glob("#{p}/**/*.rb").map {|p| p[r, 1] }.compact
  }.
  flatten.sort
puts stdlibs
bundler_paths = begin [(require 'bundler'; Bundler.bundle_path.to_s)]; rescue LoadError; [] end
gemlibs = (bundler_paths + Gem.default_path).
  compact.flatten.uniq.
  map {|p|
    r = /^#{p}\/.+\/lib\/(.+)\.rb$/
    Dir.glob("#{p}/**/lib/**/*.rb").map {|g| g[r, 1] }.compact
  }.
  flatten.sort.uniq
puts gemlibs
