module JquerySortableTreeHelper
  module RenderNestedOptionsHelper
    class Render
      attr_accessor :h, :options

      def initialize(h, options)
        @h, @options = h, options
      end

      def render_node
        @h.content_tag(:option, options[:node].send(options[:title]), tag_options) + children
      end

      def children
        @options[:children].html_safe
      end

      def tag_options
        opts = { class: "l_#{@options[:level]}", value: @options[:node][:id] }

        if @options[:selected] == @options[:node]
          opts[:class] += ' selected'
          opts[:selected] = :selected
        end
        opts
      end
    end
  end
end