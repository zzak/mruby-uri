MRuby::Gem::Specification.new('mruby-uri') do |spec|
  spec.license = 'MIT'
  spec.author  = 'zzak'
  spec.summary = 'Extension for handling URI in mruby'

  spec.add_dependency 'mruby-onig-regexp', mgem: 'mruby-onig-regexp'
  spec.add_dependency 'mruby-io', mgem: 'mruby-io'
  spec.add_dependency 'mruby-mtest', mgem: 'mruby-mtest'
end
