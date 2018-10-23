MRuby::Gem::Specification.new('mruby-uri') do |spec|
  spec.license = 'MIT'
  spec.author  = 'zzak'
  spec.summary = 'Extension for handling URI in mruby'

  
  if Dir.exist?(File.join(MRUBY_ROOT, "mrbgems", "mruby-metaprog"))
    spec.add_dependency 'mruby-metaprog', core: 'mruby-metaprog'
  end
  spec.add_dependency 'mruby-string-ext', core: 'mruby-string-ext'
  spec.add_dependency 'mruby-array-ext', core: 'mruby-array-ext'
  spec.add_dependency 'mruby-onig-regexp', mgem: 'mruby-onig-regexp'
  spec.add_test_dependency 'mruby-mtest', mgem: 'mruby-mtest'
end
