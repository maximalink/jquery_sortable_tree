# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderSortableTreeHelper
  module Render
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]
        div_item = h.content_tag(:div, handle + edit_link + controls, class: :item)
        return h.content_tag(:li, div_item + children,
          class: :node,
          data: {
            node_id: node.id,
            parent_id: node.parent_id
          }
        )
      end

      def handle
        h.content_tag(:i, '', class: :handle)
      end

      def edit_link
        h.content_tag(:h4, h.link_to(options[:node].send(options[:title]), show_path, class: :edit))
      end

      def controls
        link_options = {
          class: :delete,
          method: :delete,
          data: {
            confirm: I18n.t('are_you_sure', default: 'Are you sure?'),
            remote: true
          }
        }
        h.content_tag(:div, h.link_to('', show_path, link_options), class: :controls)
      end

      def children
        h.content_tag(:ol, options[:children].html_safe, class: :nested_set) unless options[:children].blank?
      end

      def show_path
        h.url_for(controller: options[:klass].pluralize, action: :show, id: options[:node], format: :json)
      end
    end
  end
end
