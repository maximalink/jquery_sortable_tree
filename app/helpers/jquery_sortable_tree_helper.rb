module JquerySortableTreeHelper
  # Ilya Zykin, zykin-ilya@ya.ru, Russia [Ivanovo, Saint Petersburg] 2009-2014
  # github.com/the-teacher
  TREE_RENDERERS = {
    tree: RenderTreeHelper,
    sortable: RenderSortableTreeHelper,
    expandable: RenderExpandableTreeHelper,
    nested_options: RenderNestedOptionsHelper,
    indented_options: RenderIndentedOptionsHelper,
    optgroup: RenderOptgroupHelper
  }.freeze

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
    render_module::Render.new(context, options).render_node
  end

  ###############################################
  # Shortcuts
  ###############################################

  def just_tree(tree, options = {})
    build_server_tree(tree, { type: :tree }.merge!(options))
  end

  def base_data
    {
      model: params[:controller].singularize,
      title: 'title',
      max_levels: 5,
      parent_id: params[:parent_id],
      rebuild_url: send("rebuild_#{params[:controller]}_url"),
      url: url_for(controller: params[:controller], action: :show, id: ':id', format: :json)
    }
  end

  def space(height)
    content_tag(:div, '&nbsp;'.html_safe, style: "height: #{height}px;")
  end

  def fake_node(options)
    options[:title] ||= 'title'
    OpenStruct.new(options[:title] => '', id: ':id', children: nil)
  end

  def fake_sortable_ol_tag(options)
    content_tag(:ol, build_tree_html(self, TREE_RENDERERS[:sortable], base_options.merge(options).merge({ node: fake_node(options) })), class: 'fake-node hidden', style: 'display: none;')
  end

  def real_sortable_ol_tag(tree, options)
    content_tag(:ol, build_server_tree(tree, { type: :sortable }.merge(options)),
                class: 'sortable_tree',
                data: base_data.merge(options.slice(:parent_id, :model, :rebuild_url, :title, :max_levels))
    )
  end

  def sortable_tree(tree, options = {})
    space(20) + add_new_node_form(base_data.merge(options)) + fake_sortable_ol_tag(options) + real_sortable_ol_tag(tree, options)
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
        title_field = f.text_field options[:title].to_sym, required: true, class: 'form-control', placeholder: I18n.t('sortable_tree.title_of_new_node', default: "The #{options[:title]} of new #{options[:model]}")
        concat content_tag(:div, title_field, class: 'form-group')
        concat f.hidden_field :parent_id, value: options[:parent_id]
      end
    end
  end

  def nested_options(tree, options = {})
    build_server_tree(tree, { type: :nested_options }.merge(options))
  end

  def indented_options(tree, options = {})
    build_server_tree(tree, { type: :indented_options }.merge(options))
  end

  def expandable_tree(tree, options = {})
    build_server_tree(tree, { type: :expandable }.merge(options))
  end

  def optgroup(tree, options = {})
    build_server_tree(tree, { type: :optgroup }.merge(options))
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
      namespace: [],
      controller: params[:controller]
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