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
    render_module::Render.new(self, options).render_node
  end

  ###############################################
  # Shortcuts
  ###############################################

  def just_tree(tree, options = {})
    build_server_tree(tree, { type: :tree }.merge!(options))
  end

  def base_data(tree)
    {
      model: tree.first.class.to_s.underscore,
      title: 'title',
      max_levels: 5,
      parent_id: params[:parent_id],
      rebuild_url: send("rebuild_#{tree.first.class.to_s.pluralize.underscore}_url")
    }
  end

  def sortable_tree(tree, options = {})
    base_data = base_data(tree)
    add_new_node_form(base_data.merge(options)) +
    content_tag(:ol, build_server_tree(tree, { type: :sortable }.merge!(options)),
                class: 'sortable_tree',
                data: base_data.merge(options.slice(:parent_id, :model, :rebuild_url, :title, :max_levels))
    )
  end

  def form_for_options(options)
    {
      html: { id: "new-#{options[:model]}-form" },
      url: send("#{options[:model].pluralize}_path", format: :json),
      method: :post,
      remote: true
    }
  end

  def add_new_node_form(options)
    capture do
      form_for(options[:model].to_sym, form_for_options(options)) do |f|
        concat f.text_field options[:title].to_sym, required: true,
                            placeholder: I18n.t('sortable_tree.title_of_new_node', default: "The #{options[:title]} of new #{options[:model]}")
        concat f.hidden_field :parent_id, value: options[:parent_id]
      end
    end
  end

  def nested_options(tree, options = {})
    build_server_tree(tree, { type: :nested_options }.merge!(options))
  end

  def indented_options(tree, options = {})
    build_server_tree(tree, { type: :indented_options }.merge!(options))
  end

  def expandable_tree(tree, options = {})
    build_server_tree(tree, { type: :expandable }.merge!(options))
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