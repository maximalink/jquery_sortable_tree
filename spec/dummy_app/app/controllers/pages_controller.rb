class PagesController < ApplicationController
  include JquerySortableTreeController::Rebuild
  include JquerySortableTreeController::ExpandNode

  def index
    @pages = Page.nested_set.select('id, title, content, parent_id').limit(15)
  end

  def nested_options
    @pages = Page.nested_set.select('id, title, content, parent_id').limit(15)
  end

  def indented_options
    @pages = Page.nested_set.select('id, title, content, parent_id').limit(15)
  end

  def manage
    @pages = Page.nested_set.select('id, title, content, parent_id').all
  end

  def node_manage
    @root  = Page.root
    @pages = @root.self_and_descendants.nested_set.select('id, title, content, parent_id').limit(15) if @root
    render template: 'pages/manage'
  end

  def expand
    @pages = Page.nested_set.roots.select('id, title, content, parent_id')
  end
end
