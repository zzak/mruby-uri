MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gem :core => 'mruby-string-ext'
  conf.gem :mgem => 'mruby-onig-regexp'
  conf.gem :mgem => 'mruby-io'
  conf.gem :mgem => 'mruby-mtest'

  conf.gem File.expand_path(File.dirname(__FILE__))
end
