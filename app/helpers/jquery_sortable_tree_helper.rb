module JquerySortableTreeHelper
  # Ilya Zykin, zykin-ilya@ya.ru, Russia [Ivanovo, Saint Petersburg] 2009-2014
  # github.com/the-teacher

  TREE_RENDERERS = {
    tree: RenderTreeHelper,
    sortable: RenderSortableTreeHelper,
    expandable: RenderExpandableTreeHelper,
    nested_options: RenderNestedOptionsHelper,
    indented_options: RenderIndentedOptionsHelper
  }

  ###############################################
  # Common Base Methods
  ###############################################

  def define_class_of_elements_of tree
    case
      when tree.is_a?(ActiveRecord::Relation) then tree.name.to_s.underscore.downcase
      when tree.empty?                        then nil
      else tree.first.class.to_s.underscore.downcase
    end
  end

  def build_tree_html context, render_module, options = {}
    render_module::Render::render_node(self, options)
  end

  ###############################################
  # Shortcuts
  ###############################################
  
  def just_tree tree, options = {}
    build_server_tree(tree, { :type => :tree }.merge!(options))
  end

  def sortable_tree tree, options = {}
    build_server_tree(tree, { :type => :sortable }.merge!(options))
  end

  def nested_options tree, options = {}
    build_server_tree(tree, { :type => :nested_options }.merge!(options))
  end

  def indented_options tree, options = {}
    build_server_tree(tree, { :type => :indented_options }.merge!(options))
  end

  def expandable_tree tree, options = {}
    build_server_tree(tree, { :type => :expandable }.merge!(options))
  end

  ###############################################
  # Server Side Render Tree Helper
  ###############################################

  def base_options
    {
      id: :id,
      title: :title,
      node: nil,
      type: :tree,
      root: false,
      level: 0,
      namespace: []
    }
  end

  def build_children(tree, opts)
    children = (opts[:boost][opts[:node].id.to_i] || [])
    children.reduce('') { |r, elem| r + build_server_tree(tree, opts.merge(node: elem, root: false, level: opts[:level].next)) }
  end

  def roots(tree)
    min_parent_id = tree.map(&:parent_id).compact.min
    tree.select { |e| e.parent_id == min_parent_id }
  end

  def merge_base_options(tree, options)
    opts = base_options.merge(options)
    opts[:namespace] = [*opts[:namespace]]
    opts[:render_module] ||= TREE_RENDERERS[opts[:type]]
    opts[:klass] ||= define_class_of_elements_of(tree)
    opts[:boost] ||= tree.group_by { |item| item.parent_id.to_i }
    opts
  end

  def build_server_tree(tree, options = {})
    tree = [*tree]
    opts = merge_base_options(tree, options)

    if opts[:node]
      raw build_tree_html(self, opts[:render_module], opts.merge(children: build_children(tree, opts)))
    else
      raw (roots(tree) || []).reduce('') { |r, root| r + build_server_tree(tree, opts.merge(node: root, root: true, level: opts[:level].next)) }
    end
  end
end