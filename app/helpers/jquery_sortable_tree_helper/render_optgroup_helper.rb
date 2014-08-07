module JquerySortableTreeHelper
  module RenderOptgroupHelper
    class Render < JquerySortableTreeHelper::RenderIndentedOptionsHelper::Render
      def tag_options
        html_options = super
        html_options[:disabled] = 'true' unless options[:children].blank?
        html_options
      end
    end
  end
end