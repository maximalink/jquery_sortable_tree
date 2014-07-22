require 'jquery_sortable_tree/engine'
require 'jquery_sortable_tree/version'

module JquerySortableTree
  module Scopes
    def self.included(base)
      base.class_eval do
        scope :nested_set,          -> { order('lft ASC') }
        scope :reversed_nested_set, -> { order('lft DESC') }
      end
    end
  end
end
