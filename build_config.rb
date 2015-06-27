MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'
  conf.gem :mgem => 'mruby-onig-regexp'
  conf.gem :mgem => 'mruby-mtest'

  conf.gem File.expand_path(File.dirname(__FILE__))
end
