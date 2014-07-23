module JquerySortableTreeController
  module DefineVariablesMethod
    def sortable_model
      @sortable_model ||= self.class.to_s.split(':').last.sub(/Controller/, '').singularize.constantize
    end

    def sortable_collection
      @sortable_collection ||= self.class.to_s.split(':').last.sub(/Controller/,'').underscore.downcase
    end

    def the_define_common_variables
      ["@#{sortable_collection.singularize}", sortable_collection, sortable_model]
    end

    def id
      @id ||= params[:id].to_i
    end

    def parent_id
      @parent_id ||= params[:parent_id].to_i
    end

    def sort
      @sort ||= params[:tree_sort] == 'reversed' ? 'reversed_nested_set' : 'nested_set'
    end

    def prev_id
      @prev_id ||= params[:prev_id].to_i
    end

    def next_id
      @next_id ||= params[:next_id].to_i
    end

    def move_to_prev
      @move_to_prev ||= params[:tree_sort] == 'reversed' ? :move_to_left_of : :move_to_right_of
    end

    def move_to_next
      @move_to_next ||= params[:tree_sort] == 'reversed' ? :move_to_right_of : :move_to_left_of
    end

    def move_to_parent
      :move_to_child_of
    end

    def object_to_rebuild
      self.sortable_model.find(id)
    end

    def move_to_nowhere?
      parent_id.zero? && prev_id.zero? && next_id.zero?
    end

    def prev_next_parent
      return 'prev' unless prev_id.zero?
      return 'next' unless next_id.zero?
      return 'parent' unless parent_id.zero?
    end

    def move_to
      send("move_to_#{prev_next_parent}")
    end

    def node_id
      send("#{prev_next_parent}_id")
    end

    def node
      sortable_model.find(node_id)
    end
  end

  module ExpandNode
    include DefineVariablesMethod

    def expand_node
      @children = object_to_rebuild.children.send(sort) if id && sort
      return render(nothing: true, status: :no_content) if !@children || @children.count.zero?
      render layout: false, template: "#{sortable_collection}/expand_node"
    end
  end

  module Rebuild
    include DefineVariablesMethod

    def rebuild
      return render(nothing: true, status: :no_content) if move_to_nowhere?
      object_to_rebuild.send(move_to, node)
      render(nothing: true, status: :ok)
    end
  end
end
