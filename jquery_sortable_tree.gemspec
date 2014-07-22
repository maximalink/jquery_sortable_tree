$:.push File.expand_path("../lib", __FILE__)
require 'jquery_sortable_tree/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jquery_sortable_tree'
  s.version     = JquerySortableTree::VERSION
  s.authors     = ['Ilya N. Zykin', 'Jozsef Nyitrai', 'Mikhail Dieterle', 'Matthew Clark']
  s.email       = ['nyitrai@maximalink.com', 'zykin-ilya@ya.ru']
  s.homepage    = 'https://github.com/maximalink/jquery_sortable_tree'
  s.summary     = %q{Drag&Drop GUI for awesom_nested_set. Render Tree Helper. Very fast! Ready for Rails 4}
  s.description = %q{Drag&Drop GUI for awesom_nested_set. Render Tree Helper. Very fast! Ready for Rails 4}
  s.rubyforge_project = 'jquery_sortable_tree'
  s.extra_rdoc_files = ['README.md']

  s.files = Dir["{app,config,db,lib}/**/*"] + ['MIT-LICENSE', 'Rakefile']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 3.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
end
