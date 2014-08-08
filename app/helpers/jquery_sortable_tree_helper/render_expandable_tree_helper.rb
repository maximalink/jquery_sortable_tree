# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module JquerySortableTreeHelper
  module RenderExpandableTreeHelper
    class Render < JquerySortableTreeHelper::RenderSortableTreeHelper::Render
      def div_item
        h.content_tag(:div, handle + expand_button + edit_link + controls, class: :item)
      end

      def expand_button
        h.content_tag(:b, '+', class: 'expand plus')
      end
    end
  end
end
