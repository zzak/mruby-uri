MRuby::Gem::Specification.new('mruby-uri') do |spec|
  spec.license = 'MIT'
  spec.author  = 'zzak'
  spec.summary = 'Extension for handling URI in mruby'

  spec.add_dependency 'mruby-string-ext', core: 'mruby-string-ext'
  spec.add_dependency 'mruby-array-ext', core: 'mruby-array-ext'

  if File.exist? "#{MRUBY_ROOT}/mrbgems/mruby-pack"
    spec.add_dependency 'mruby-pack', core: 'mruby-pack'
  else
    spec.add_dependency 'mruby-pack', mgem: 'mruby-pack'
  end

  spec.add_dependency 'mruby-onig-regexp', mgem: 'mruby-onig-regexp'
  spec.add_test_dependency 'mruby-mtest', mgem: 'mruby-mtest'
end
