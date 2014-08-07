# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module JquerySortableTreeHelper
  module RenderTreeHelper
    class Render < JquerySortableTreeHelper::RenderSortableTreeHelper::Render
      def div_item
        h.content_tag(:div, show_link, class: :item)
      end
    end
  end
end