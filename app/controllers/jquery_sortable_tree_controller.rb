module JquerySortableTreeController
  module DefineVariablesMethod
    public
    def the_define_common_variables
      collection = self.class.to_s.split(':').last.sub(/Controller/,'').underscore.downcase                 # 'recipes'
      collection = self.respond_to?(:sortable_collection) ? self.sortable_collection : collection           # 'recipes'
      variable   = collection.singularize                                                                   # 'recipe'
      klass      = self.respond_to?(:sortable_model) ? self.sortable_model : variable.classify.constantize  #  Recipe
      ["@#{variable}", collection, klass]
    end
  end

  module Params
    def id
      @id ||= params[:id].to_i
    end

    def parent_id
      @parent_id ||= params[:parent_id].to_i
    end

    def sort
      @sort ||= 'reversed_nested_set' if params[:tree_sort] == 'reversed'
    end

    def prev_id
      @prev_id ||= params[:prev_id].to_i
    end

    def next_id
      @next_id ||= params[:next_id].to_i
    end

    def move_to_nowhere?
      parent_id.zero? && prev_id.zero? && next_id.zero?
    end
  end

  module ExpandNode
    include DefineVariablesMethod
    include Params

    def expand_node
      return render(nothing: true, status: :no_content) unless id

      variable, collection, klass = self.the_define_common_variables
      variable  = self.instance_variable_set(variable, klass.find(id))
      @children = variable.children.send(sort)

      return render(nothing: true, status: :no_content) if @children.count.zero?
      render layout: false, template: "#{collection}/expand_node"
    end
  end

  module Rebuild
    include DefineVariablesMethod
    include Params

    def rebuild
      return render(nothing: true, status: :no_content) if move_to_nowhere?

      variable, collection, klass = the_define_common_variables
      variable = instance_variable_set(variable, klass.find(id))

      if prev_id.zero? && next_id.zero?
        variable.move_to_child_of klass.find(parent_id)
      elsif !prev_id.zero?
        variable.move_to_right_of klass.find(prev_id)
      elsif !next_id.zero?
        variable.move_to_left_of klass.find(next_id)
      end

      render(nothing: true, status: :ok)
    end
  end

  module ReversedRebuild
    include DefineVariablesMethod
    include Params

    def rebuild
      return render(nothing: true, status: :no_content) if move_to_nowhere?

      variable, collection, klass = the_define_common_variables
      variable = instance_variable_set(variable, klass.find(id))

      if prev_id.zero? && next_id.zero?
        variable.move_to_child_of klass.find(parent_id)
      elsif !prev_id.zero?
        variable.move_to_left_of klass.find(prev_id)
      elsif !next_id.zero?
        variable.move_to_right_of klass.find(next_id)
      end

      render(nothing: true, status: :ok)
    end
  end
end
