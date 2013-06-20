b =
  begin
    require "bundler"
    [Bundler::bundle_path.to_s]
  rescue
    []
  end
puts $LOAD_PATH.grep(/ruby\/\d\.\d\.\d$/).
  map {|l| Dir.glob(l+"/**/*").map{|p| p[/#{l}\/(.+)\.rb$/, 1] }.
  flatten.compact.sort +
  (b + Gem::default_path).map {|p| Dir.glob(p+"/**/*.rb").map{|g| g[/#{p}\/.+\/lib\/(.+)\.rb$/, 1] }}.
  flatten.compact.sort.uniq
