class Admin::PagesController < ApplicationController
  include JquerySortableTreeController::Rebuild

  before_action :load_pages, only: [:index, :manage, :nested_options, :indented_options, :optgroup]

  def index
  end

  def manage
  end

  def nested_options
  end

  def indented_options
  end

  def optgroup
  end

  def node_manage
    @root  = Admin::Page.root
    @pages = @root.self_and_descendants.nested_set.select('id, title, content, parent_id').limit(15) if @root
    render template: 'admin/pages/manage'
  end

  protected

  def load_pages
    @pages = Admin::Page.nested_set.select('id, title, content, parent_id').limit(15)
  end

  def sortable_model
    Admin::Page
  end

  def sortable_collection
    'admin_pages'
  end
end
