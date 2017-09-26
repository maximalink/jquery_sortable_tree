$:.push File.expand_path("../lib", __FILE__)
require 'jquery_sortable_tree/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jquery_sortable_tree'
  s.version     = JquerySortableTree::VERSION
  s.authors     = ['Ilya N. Zykin', 'Jozsef Nyitrai', 'Mikhail Dieterle', 'Matthew Clark']
  s.email       = ['nyitrai@maximalink.com', 'zykin-ilya@ya.ru']
  s.homepage    = 'https://github.com/maximalink/jquery_sortable_tree'
  s.summary     = %q{Rails Drag&Drop GUI gem for managing awesom_nested_set.}
  s.licenses    = ['MIT']
  s.description = %q{Drag&Drop GUI, inline node editing and new node creating. Ready for Rails 4}
  s.rubyforge_project = 'jquery_sortable_tree'
  s.extra_rdoc_files = ['README.md']

  s.files = Dir["{app,config,db,lib}/**/*"] + ['MIT-LICENSE', 'Rakefile']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 3.1'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'awesome_nested_set', '~> 3.0.0.rc5'
end
