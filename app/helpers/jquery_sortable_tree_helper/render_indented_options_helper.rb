module JquerySortableTreeHelper
  module RenderIndentedOptionsHelper
    class Render
      attr_accessor :h, :options

      def initialize(h, options)
        @h, @options = h, options
      end

      def render_node
        h.content_tag(:option, title, tag_options) + children
      end

      def title
        "\u202f" * (@options[:spacing] || 3).to_i * (@options[:level]-1) + node.send(@options[:title])
      end

      def tag_options
        html_options = { value: node.id }

        if options[:selected] == node
          html_options[:selected] = 'selected'
          html_options[:class] = 'selected'
        end
        html_options
      end

      def node
        @options[:node]
      end

      def children
        @options[:children].html_safe
      end
    end
  end
end
