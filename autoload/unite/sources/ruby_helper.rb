require "bundler"
stdlibs = $LOAD_PATH.grep(/ruby\/\d\.\d\.\d$/).
  map {|l|
    Dir.glob("#{l}/**/*.rb").
      map {|p| p[/#{l}\/(.+)\.rb$/, 1] }
  }.
  flatten.compact.sort
gemlibs = (([Bundler.bundle_path.to_s] rescue []) + Gem.default_path).
  map {|p|
    Dir.glob("#{p}/**/lib/**/*.rb").
      map{|g| g[/#{p}\/.+\/lib\/(.+)\.rb$/, 1] }
  }.
  flatten.compact.sort.uniq
#puts stdlibs + gemlibs
p [stdlibs.size, gemlibs.size]
