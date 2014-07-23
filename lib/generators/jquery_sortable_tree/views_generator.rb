module JquerySortableTree
  module Generators
    class ViewsGenerator < Rails::Generators::NamedBase
      APP_DIR = File.expand_path('../../../../app/', __FILE__)
      FILES_FOR_NAMES = {
        tree: 'helpers/render_tree_helper.rb',
        sortable: 'helpers/render_sortable_tree_helper.rb',
        nested_options: 'helpers/render_nested_options_helper.rb',
        indented_options: 'helpers/render_indented_options_helper.rb',
        helper: 'helpers/jquery_sortable_tree_helper.rb',
        assets: 'assets'
      }.freeze

      source_root APP_DIR

      def self.banner
<<-BANNER.chomp

bundle exec rails g jquery_sortable_tree:views tree
bundle exec rails g jquery_sortable_tree:views sortable
bundle exec rails g jquery_sortable_tree:views nested_options
bundle exec rails g jquery_sortable_tree:views indented_options
bundle exec rails g jquery_sortable_tree:views helper
bundle exec rails g jquery_sortable_tree:views assets

BANNER
      end

      def copy_sortable_tree_files
        copy_helper_files
      end

      private

      def filename
        FILES_FOR_NAMES[name.downcase.to_sym]
      end

      def is_directory?
        File.directory?(File.join(APP_DIR, filename))
      end

      def copy_command
        is_directory? ? :directory : :copy_file
      end

      def copy_helper_files
        if filename
          send(copy_command, filename, File.join('app', filename))
        else
          puts "Wrong parameter - use only [#{FILES_FOR_NAMES.keys.map(&:to_s).join(' | ')}] values"
        end
      end
    end
  end
end
