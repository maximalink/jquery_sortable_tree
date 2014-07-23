# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderTreeHelper
  class Render < RenderSortableTreeHelper::Render
    attr_accessor :h, :options

    def initialize(h, options)
      @h, @options = h, options
    end

    def div_item
      h.content_tag(:div, show_link, class: :item)
    end
  end
end