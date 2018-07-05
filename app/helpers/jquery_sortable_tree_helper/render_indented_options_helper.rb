module JquerySortableTreeHelper
  module RenderIndentedOptionsHelper
    class Render < JquerySortableTreeHelper::RenderSortableTreeHelper::Render
      def render_node
        h.content_tag(:option, title, tag_options) + children
      end

      def title
        "\u202f" * (@options[:spacing] || 3).to_i * (@options[:level] - 1) + node.send(@options[:title])
      end

      def tag_options
        html_options = { value: node.id }

        if node_selected?(options[:selected], node)
          html_options[:selected] = 'selected'
          html_options[:class] = 'selected'
        end
        html_options
      end

      def children
        @options[:children].html_safe
      end

      private

      def node_selected?(selected, node)
        selected.present? && node.present? && ((selected.is_a?(Enumerble) && (selected.include?(node.id) || selected.include?(node))) || selected == node || selected == node.id)
      end
    end
  end
end
