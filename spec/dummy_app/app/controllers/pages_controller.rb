class PagesController < ApplicationController
  include JquerySortableTreeController::Rebuild
  include JquerySortableTreeController::ExpandNode

  before_action :load_pages, only: [:index, :nested_options, :indented_options, :optgroup]

  def index
  end

  def nested_options
  end

  def indented_options
  end

  def optgroup
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

  private

  def load_pages
    @pages = Page.nested_set.select('id, title, content, parent_id').limit(15)
  end
end
