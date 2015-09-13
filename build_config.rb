MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gem File.expand_path(File.dirname(__FILE__))
end
